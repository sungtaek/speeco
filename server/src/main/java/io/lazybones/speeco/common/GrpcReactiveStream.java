package io.lazybones.speeco.common;

import java.util.function.Function;
import java.util.function.Supplier;

import io.grpc.stub.StreamObserver;
import reactor.core.publisher.BaseSubscriber;
import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxSink;
import reactor.core.publisher.Mono;

public class GrpcReactiveStream {

  public static class GrpcRequestStreamObserver<Req> implements StreamObserver<Req> {

    private final Flux<Req> requestFlux;
    private FluxSink<Req> emitter;

    public GrpcRequestStreamObserver() {
      this.requestFlux = Flux.<Req>create(emitter -> this.emitter = emitter);
    }

    public Flux<Req> getRequestFlux() {
      return requestFlux;
    }

    @Override
    public void onNext(Req req) {
      emitter.next(req);
    }

    @Override
    public void onError(Throwable t) {
      emitter.error(t);
    }

    @Override
    public void onCompleted() {
      emitter.complete();
    }
  }

  public static class GrpcResponseSubscriber<Resp> extends BaseSubscriber<Resp> {
    private final StreamObserver<Resp> responseObserver;

    public GrpcResponseSubscriber(StreamObserver<Resp> responseObserver) {
      this.responseObserver = responseObserver;
    }

    @Override
    public void hookOnNext(Resp resp) {
      responseObserver.onNext(resp);
    }

    @Override
    public void hookOnError(Throwable t) {
      responseObserver.onError(t);
    }

    @Override
    public void hookOnComplete() {
      responseObserver.onCompleted();
    }
  }
  
  public static <Req, Resp> StreamObserver<Req> bindBidiStreaming(StreamObserver<Resp> responseObserver, Function<Flux<Req>, Flux<Resp>> handler) {
    GrpcRequestStreamObserver<Req> requestStreamObserver = new GrpcRequestStreamObserver<>();
    requestStreamObserver.getRequestFlux()
        .transform(handler)
        .subscribe(new GrpcResponseSubscriber<>(responseObserver));
    return requestStreamObserver;
  }

  public static <Resp> void bindServerStreaming(StreamObserver<Resp> responseObserver, Supplier<Flux<Resp>> handler) {
    handler.get()
        .subscribe(new GrpcResponseSubscriber<>(responseObserver));
  }

  public static <Resp> void bindUnary(StreamObserver<Resp> responseObserver, Supplier<Mono<Resp>> handler) {
    handler.get()
        .subscribe(new GrpcResponseSubscriber<>(responseObserver));
  }

}
