package io.lazybones.speeco.asr;

import org.springframework.stereotype.Controller;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcReactiveStream;
import io.lazybones.speeco.common.Util;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.grpc.ASRGrpc.ASRImplBase;
import io.lazybones.speeco.grpc.Audio;
import io.lazybones.speeco.grpc.Message;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ASRController extends ASRImplBase {

  private final ASRService asrService;

  public ASRController(ASRService asrService) {
    this.asrService = asrService;
  }

  @Override
  public StreamObserver<Audio> recognize(StreamObserver<Message> responseObserver) {
    Conversation conversation = Conversation.DEFAULT;
    return GrpcReactiveStream.bindBidiStreaming(responseObserver, reqFlux -> {
      return reqFlux
          .doOnNext(r -> log.info("Receive: {}", Util.toLogString(r)))
          .mapNotNull(this::convertRequest)
          .transform(audioFlux -> asrService.recognize(conversation, audioFlux))
          .map(this::convertResponse)
          .doOnNext(r -> log.info("Return: {}", Util.toLogString(r)))
          .doOnError(err -> log.error("Error: " + err.getMessage(), err))
          .doOnComplete(() -> log.info("Completed"));
    });
  }

  private byte[] convertRequest(Audio req) {
    return req.getPcm().toByteArray();
  }

  private Message convertResponse(String resp) {
    return Message.newBuilder()
        .setText(resp)
        .build();
  }

}
