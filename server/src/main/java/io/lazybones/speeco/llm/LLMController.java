package io.lazybones.speeco.llm;

import org.springframework.stereotype.Controller;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcReactiveStream;
import io.lazybones.speeco.common.Util;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.grpc.Message;
import io.lazybones.speeco.grpc.LLMGrpc.LLMImplBase;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class LLMController extends LLMImplBase {

  private final LLMService llmService;

  public LLMController(LLMService llmService) {
    this.llmService = llmService;
  }

  @Override
  public void chat(Message request, StreamObserver<Message> responseObserver) {
    Conversation conversation = Conversation.DEFAULT;
    GrpcReactiveStream.bindServerStreaming(responseObserver, () -> {
      log.info("Receive: {}", Util.toLogString(request));
      return llmService.chat(conversation, request.getText())
          .map(this::convertResponse)
          .doOnNext(r -> log.info("Return: {}", Util.toLogString(r)))
          .doOnError(err -> log.error("Error: " + err.getMessage(), err))
          .doOnComplete(() -> log.info("Completed"));
    });
  }

  private Message convertResponse(String resp) {
    return Message.newBuilder()
        .setText(resp)
        .build();
  }

}
