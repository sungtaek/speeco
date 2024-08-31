package io.lazybones.speeco.speech;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import io.lazybones.speeco.asr.ASR;
import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Speaker;
import io.lazybones.speeco.llm.LLM;
import io.lazybones.speeco.speech.model.Speech;
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

  @Data
  private static class Context {
    private Speech lastUserSpeech;
  }

  public SpeechService(ASR asr, LLM llm, TTS tts) {
    this.asr = asr;
    this.llm = llm;
    this.tts = tts;
  }

  public Flux<Speech> speech(Conversation conversation, Flux<Speech> speechFlux) {
    Context context = new Context();

    return Flux.concat(
        speechFlux
            .map(Speech::getAudio)
            .transform(asr::recognize)
            .map(recognized -> Speech.builder()
                .speaker(Speaker.USER)
                .text(recognized.getText())
                .build())
            .doOnNext(context::setLastUserSpeech)
            .doOnComplete(() -> {
              String userText = context.getLastUserSpeech().getText();
              conversation.getMessages().add(new Message(Speaker.USER, userText));
            }),
        Flux.defer(() -> request(conversation, context.getLastUserSpeech())));
  }

  private Flux<Speech> request(Conversation conversation, Speech userSpeech) {
    if (userSpeech == null || StringUtils.isBlank(userSpeech.getText())) {
      return Flux.empty();
    }

    Coach coach = conversation.getCoach();
    List<Message> messages = conversation.getMessages();
    messages.add(new Message(Speaker.USER, userSpeech.getText()));

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
