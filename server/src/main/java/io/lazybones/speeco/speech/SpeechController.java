package io.lazybones.speeco.speech;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;

import com.google.protobuf.ByteString;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcBidiReactiveStream;
import io.lazybones.speeco.common.Util;
import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Speaker;
import io.lazybones.speeco.common.model.Speech;
import io.lazybones.speeco.common.model.User;
import io.lazybones.speeco.grpc.SpeechRequest;
import io.lazybones.speeco.grpc.SpeechResponse;
import io.lazybones.speeco.grpc.SpeecoInterfaceGrpc.SpeecoInterfaceImplBase;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SpeechController extends SpeecoInterfaceImplBase {

  private final SpeechService speechService;

  public SpeechController(SpeechService speechService) {
    this.speechService = speechService;
  }

  @Override
  public StreamObserver<SpeechRequest> speech(StreamObserver<SpeechResponse> responseObserver) {
    Conversation conversation = Conversation.builder()
        .id("conv-0001")
        .user(User.builder()
            .name("user")
            .build())
        .coach(Coach.builder()
            .name("coach")
            .gender("M")
            .model("teacher")
            .language("en")
            .voice("larynx:southern_english_male-glow_tts")
            .build())
        .messages(new ArrayList<>())
        .build();
    return new GrpcBidiReactiveStream<>(responseObserver,
        reqFlux -> {
          return reqFlux
              .doOnNext(r -> log.info("Receive: {}", Util.toLogString(r)))
              .mapNotNull(this::convertRequest)
              .transform(speechFlux -> speechService.speech(conversation, speechFlux))
              .map(this::convertResponse)
              .doOnNext(r -> log.info("Return: {}", Util.toLogString(r)))
              .doOnError(err -> log.error("Error: " + err.getMessage(), err))
              .doOnComplete(() -> log.info("Completed"))
              ;
        });
  }

  private Speech convertRequest(SpeechRequest req) {
    io.lazybones.speeco.grpc.Speech userSpeech = req.getUserSpeech();
    if (userSpeech != null) {
      return Speech.builder()
          .speaker(Speaker.USER)
          .audio(userSpeech.getAudio() != null ? userSpeech.getAudio().toByteArray() : null)
          .text(userSpeech.getText())
          .build();
    } else {
      return null;
    }
  }

  private SpeechResponse convertResponse(Speech resp) {
    io.lazybones.speeco.grpc.Speech.Builder speechBuilder = io.lazybones.speeco.grpc.Speech.newBuilder();
    if (resp.getAudio() != null) {
      speechBuilder.setAudio(ByteString.copyFrom(resp.getAudio()));
    }
    if (resp.getText() != null) {
      speechBuilder.setText(resp.getText());
    }

    if (resp.getSpeaker() == Speaker.USER) {
      return SpeechResponse.newBuilder()
          .setUserSpeech(speechBuilder)
          .build();
    } else {
      return SpeechResponse.newBuilder()
          .setCoachSpeech(speechBuilder)
          .build();
    }
  }

}
