package io.lazybones.speeco.speech;

import org.springframework.stereotype.Controller;

import com.google.protobuf.ByteString;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcBidiReactiveStream;
import io.lazybones.speeco.grpc.SpeecoInterfaceGrpc.SpeecoInterfaceImplBase;
import io.lazybones.speeco.speech.model.Speaker;
import io.lazybones.speeco.speech.model.SpeechRequest;
import io.lazybones.speeco.speech.model.SpeechResponse;

@Controller
public class SpeechController extends SpeecoInterfaceImplBase {

  private final SpeechService speechService;

  public SpeechController(SpeechService speechService) {
    this.speechService = speechService;
  }

  @Override
  public StreamObserver<io.lazybones.speeco.grpc.SpeechRequest> speech(StreamObserver<io.lazybones.speeco.grpc.SpeechResponse> responseObserver) {
    return new GrpcBidiReactiveStream<>(responseObserver,
        reqFlux -> {
          return reqFlux
              .map(this::convertRequest)
              .transform(speechService::speech)
              .map(this::convertResponse);
        });
  }

  private SpeechRequest convertRequest(io.lazybones.speeco.grpc.SpeechRequest req) {
    return SpeechRequest.builder()
        .audio(req.toByteArray())
        .done(req.getDone())
        .build();
  }

  private io.lazybones.speeco.grpc.SpeechResponse convertResponse(SpeechResponse resp) {
    return io.lazybones.speeco.grpc.SpeechResponse.newBuilder()
        .setSpeaker(convertSpeaker(resp.getSpeaker()))
        .setAudio(ByteString.copyFrom(resp.getAudio()))
        .setDone(resp.getDone())
        .build();
  }

  private io.lazybones.speeco.grpc.Speaker convertSpeaker(Speaker speaker) {
    switch (speaker) {
      case USER:
        return io.lazybones.speeco.grpc.Speaker.USER;
      case COACH:
        return io.lazybones.speeco.grpc.Speaker.COACH;
    }
    return io.lazybones.speeco.grpc.Speaker.UNRECOGNIZED;
  }

}
