package io.lazybones.speeco.tts;

import org.springframework.stereotype.Controller;

import com.google.protobuf.ByteString;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcReactiveStream;
import io.lazybones.speeco.common.Util;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.grpc.Audio;
import io.lazybones.speeco.grpc.Message;
import io.lazybones.speeco.grpc.TTSGrpc.TTSImplBase;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class TTSController extends TTSImplBase {

  private final TTSService ttsService;

  public TTSController(TTSService ttsService) {
    this.ttsService = ttsService;
  }

  @Override
  public void convert(Message request, StreamObserver<Audio> responseObserver) {
    Conversation conversation = Conversation.DEFAULT;
    GrpcReactiveStream.bindUnary(responseObserver, () -> {
      log.info("Receive: {}", Util.toLogString(request));
      return ttsService.convert(conversation, request.getText())
          .map(this::convertResponse)
          .doOnSuccess(r -> log.info("Return: {}", Util.toLogString(r)))
          .doOnError(err -> log.error("Error: " + err.getMessage(), err));
    });
  }

  private Audio convertResponse(byte[] resp) {
    return Audio.newBuilder()
        .setPcm(ByteString.copyFrom(resp))
        .build();
  }

}
