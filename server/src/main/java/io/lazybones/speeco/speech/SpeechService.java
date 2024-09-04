package io.lazybones.speeco.speech;

import java.util.List;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.asr.ASR;
import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Speaker;
import io.lazybones.speeco.common.model.Speech;
import io.lazybones.speeco.llm.LLM;
import io.lazybones.speeco.tts.TTS;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;

@Service
@Slf4j
public class SpeechService {
  private final ASR asr;
  private final LLM llm;
  private final TTS tts;

  public SpeechService(ASR asr, LLM llm, TTS tts) {
    this.asr = asr;
    this.llm = llm;
    this.tts = tts;
  }

  @Data
  private static class Context {
    private Speech lastUserSpeech;
  }

  public Flux<Speech> speech(Conversation conversation, Flux<Speech> userSpeechFlux) {
    Context context = new Context();
    return Flux.concat(
        recognizeUserSpeech(userSpeechFlux)
            .doOnNext(context::setLastUserSpeech)
            .doOnComplete(() -> conversation.addSpeech(context.getLastUserSpeech())),
        Flux.defer(() -> requestCoach(conversation)));
  }

  private Flux<Speech> recognizeUserSpeech(Flux<Speech> userSpeechFlux) {
    return userSpeechFlux
        .map(Speech::getAudio)
        .transform(asr::recognize)
        .map(recognized -> Speech.builder()
            .speaker(Speaker.USER)
            .text(recognized.getText())
            .build());
  }

  private Flux<Speech> requestCoach(Conversation conversation) {
    Coach coach = conversation.getCoach();
    List<Message> messages = conversation.getMessages();

    return llm.chat(coach.getModel(), messages)
        .concatMap(text -> {
          return tts.tts(coach.getVoice(), text)
              .map(audio -> Speech.builder()
                  .speaker(Speaker.COACH)
                  .audio(audio)
                  .text(text)
                  .build());
        });
  }

}
