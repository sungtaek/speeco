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

  public Flux<Speech> speech(Conversation conversation, Flux<Speech> userSpeechFlux) {
    return Flux.concat(
      recognizeUserSpeech(conversation, userSpeechFlux),
      Flux.defer(() -> requestCoach(conversation)));
  }

  @Data
  private static class RecognizeContext {
    private Speech lastUserSpeech;
  }

  private Flux<Speech> recognizeUserSpeech(Conversation conversation, Flux<Speech> userSpeechFlux) {
    RecognizeContext context = new RecognizeContext();
    Flux<Speech> recognizedFlux;
    if (conversation.getUseAsr()) {
      recognizedFlux = userSpeechFlux
          .map(Speech::getAudio)
          .transform(asr::recognize)
          .map(recognized -> Speech.builder()
              .speaker(Speaker.USER)
              .text(recognized.getText())
              .build());
    } else {
      recognizedFlux = userSpeechFlux;
    }
    return recognizedFlux
      .doOnNext(context::setLastUserSpeech)
      .doOnComplete(() -> conversation.addSpeech(context.getLastUserSpeech()));
  }

  private Flux<Speech> requestCoach(Conversation conversation) {
    Coach coach = conversation.getCoach();
    List<Message> messages = conversation.getMessages();
    Flux<String> coachAnswerFlux = llm.chat(coach.getModel(), messages);
    if (conversation.getUseTts()) {
      return coachAnswerFlux
          .concatMap(text -> {
            return tts.tts(coach.getVoice(), text)
                .map(audio -> Speech.builder()
                    .speaker(Speaker.COACH)
                    .audio(audio)
                    .text(text)
                    .build());
          });
    } else {
      return coachAnswerFlux
          .map(text -> Speech.builder()
              .speaker(Speaker.COACH)
              .text(text)
              .build());
    }
  }
}
