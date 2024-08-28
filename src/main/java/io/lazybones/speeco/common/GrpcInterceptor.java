package io.lazybones.speeco.common;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import io.grpc.ServerInterceptor;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface GrpcInterceptor {
  Class<? extends ServerInterceptor>[] value();
}
