package io.lazybones.speeco.llm;

import org.springframework.stereotype.Controller;

import io.grpc.stub.StreamObserver;
import io.lazybones.speeco.common.GrpcInterceptor;
import io.lazybones.speeco.common.GrpcMetadataInterceptor;
import io.lazybones.speeco.common.GrpcReactiveStream;
import io.lazybones.speeco.common.Util;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Owner;
import io.lazybones.speeco.grpc.LLMGrpc.LLMImplBase;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Controller
@GrpcInterceptor(GrpcMetadataInterceptor.class)
@Slf4j
public class LLMController extends LLMImplBase {
  private static final String METADATA_CONVERSATION_ID = "conv-id";

  private final GrpcMetadataInterceptor grpcMetadataInterceptor;
  private final LLMService llmService;

  public LLMController(GrpcMetadataInterceptor grpcMetadataInterceptor, LLMService llmService) {
    this.grpcMetadataInterceptor = grpcMetadataInterceptor;
    this.llmService = llmService;
  }

  @Override
  public void create(io.lazybones.speeco.grpc.Empty empty,
      StreamObserver<io.lazybones.speeco.grpc.Conversation> responseObserver) {
    GrpcReactiveStream.bindUnary(responseObserver, () -> {
      return Mono.just(llmService.createConversation())
          .map(c -> io.lazybones.speeco.grpc.Conversation.newBuilder()
              .setId(c.getId())
              .setUser(c.getUser().getName())
              .setCoach(c.getCoach().getName())
              .addAllMessages(c.getMessages().stream().map(this::convertMessage).toList())
              .build());
    });
  }

  @Override
  public void chat(io.lazybones.speeco.grpc.Message request,
      StreamObserver<io.lazybones.speeco.grpc.Message> responseObserver) {
    String convId = grpcMetadataInterceptor.getString(METADATA_CONVERSATION_ID);
    Conversation conversation = llmService.getConversation(convId);
    if (conversation == null) {
      throw new RuntimeException("Cannot find conversation");
    }
    GrpcReactiveStream.bindServerStreaming(responseObserver, () -> {
      log.info("Receive: {}", Util.toLogString(request));
      return llmService.chat(conversation, request.getText())
          .map(this::convertMessage)
          .doOnNext(r -> log.info("Return: {}", Util.toLogString(r)))
          .doOnError(err -> log.error("Error: " + err.getMessage(), err))
          .doOnComplete(() -> log.info("Completed"));
    });
  }

  private io.lazybones.speeco.grpc.Message convertMessage(Message message) {
    return io.lazybones.speeco.grpc.Message.newBuilder()
        .setOwner(convertOwner(message.getOwner()))
        .setText(message.getText())
        .build();
  }

  private io.lazybones.speeco.grpc.Owner convertOwner(Owner owner) {
    switch(owner) {
      case USER: return io.lazybones.speeco.grpc.Owner.USER;
      case COACH: return io.lazybones.speeco.grpc.Owner.COACH;
      default: return io.lazybones.speeco.grpc.Owner.UNRECOGNIZED;
    }
  }

}
