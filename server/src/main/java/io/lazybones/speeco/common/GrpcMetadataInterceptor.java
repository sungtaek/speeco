package io.lazybones.speeco.common;

import org.springframework.stereotype.Component;

import io.grpc.ForwardingServerCallListener.SimpleForwardingServerCallListener;
import io.grpc.Metadata;
import io.grpc.Metadata.AsciiMarshaller;
import io.grpc.Metadata.BinaryMarshaller;
import io.grpc.ServerCall;
import io.grpc.ServerCall.Listener;
import io.grpc.ServerCallHandler;
import io.grpc.ServerInterceptor;

@Component
public class GrpcMetadataInterceptor implements ServerInterceptor {

  private final ThreadLocal<Metadata> metadata = new ThreadLocal<>();

  @Override
  public <ReqT, RespT> Listener<ReqT> interceptCall(ServerCall<ReqT, RespT> call, Metadata headers,
      ServerCallHandler<ReqT, RespT> next) {
    metadata.set(headers);
    try {
      return new SimpleForwardingServerCallListener<ReqT>(next.startCall(call, headers)) {
        @Override
        public void onMessage(ReqT message) {
          metadata.set(headers);
          super.onMessage(message);
          metadata.remove();
        }

        @Override
        public void onHalfClose() {
          metadata.set(headers);
          super.onHalfClose();
          metadata.remove();
        }

        @Override
        public void onCancel() {
          metadata.set(headers);
          super.onCancel();
          metadata.remove();
        }

        @Override
        public void onComplete() {
          metadata.set(headers);
          super.onComplete();
          metadata.remove();
        }

        @Override
        public void onReady() {
          metadata.set(headers);
          super.onReady();
          metadata.remove();
        }
      };
    } finally {
      metadata.remove();
    }
  }

  public String getString(String key) {
    return get(key, Metadata.ASCII_STRING_MARSHALLER);
  }

  public String getString(String key, String defaultValue) {
    return get(key, Metadata.ASCII_STRING_MARSHALLER, defaultValue);
  }

  public byte[] getBytes(String key) {
    return get(key, Metadata.BINARY_BYTE_MARSHALLER);
  }

  public byte[] getBytes(String key, byte[] defaultValue) {
    return get(key, Metadata.BINARY_BYTE_MARSHALLER, defaultValue);
  }

  public <T> T get(String key, BinaryMarshaller<T> marshaller) {
    if (metadata.get() != null) {
      return metadata.get().get(Metadata.Key.of(key, marshaller));
    }
    return null;
  }

  public <T> T get(String key, BinaryMarshaller<T> marshaller, T defaultValue) {
    if (metadata.get() != null) {
      T value = metadata.get().get(Metadata.Key.of(key, marshaller));
      return value != null ? value : defaultValue;
    }
    return defaultValue;
  }

  public <T> T get(String key, AsciiMarshaller<T> marshaller) {
    if (metadata.get() != null) {
      return metadata.get().get(Metadata.Key.of(key, marshaller));
    }
    return null;
  }

  public <T> T get(String key, AsciiMarshaller<T> marshaller, T defaultValue) {
    if (metadata.get() != null) {
      T value = metadata.get().get(Metadata.Key.of(key, marshaller));
      return value != null ? value : defaultValue;
    }
    return defaultValue;
  }
  
}
