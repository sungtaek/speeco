package io.lazybones.speeco.common;

import java.util.function.Function;

import io.grpc.stub.StreamObserver;
import reactor.core.publisher.BaseSubscriber;
import reactor.core.publisher.Flux;
import reactor.core.publisher.FluxSink;

public class GrpcBidiReactiveStream<Req, Resp> implements StreamObserver<Req> {
  private final Flux<Req> requestFlux;
  private FluxSink<Req> emitter;

  public GrpcBidiReactiveStream(StreamObserver<Resp> responseObserver, Function<Flux<Req>, Flux<Resp>> handler) {
    this.requestFlux = Flux.<Req>create(emitter -> this.emitter = emitter);
    this.requestFlux.transform(handler).subscribe(new ResponseSubscriber(responseObserver));
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

  public class ResponseSubscriber extends BaseSubscriber<Resp> {
    private final StreamObserver<Resp> responseObserver;

    public ResponseSubscriber(StreamObserver<Resp> responseObserver) {
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

}
