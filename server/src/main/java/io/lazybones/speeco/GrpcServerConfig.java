package io.lazybones.speeco;

import java.io.IOException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.grpc.BindableService;
import io.grpc.Grpc;
import io.grpc.InsecureServerCredentials;
import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.ServerInterceptor;
import io.grpc.ServerInterceptors;
import io.lazybones.speeco.common.GrpcInterceptor;
import lombok.extern.slf4j.Slf4j;

@Configuration
@Slf4j
public class GrpcServerConfig {

  @Bean
  public Server grpcServer(
      @Value("${server.grpc-port:9090}") Integer grpcPort,
      List<BindableService> grpcServices,
      List<ServerInterceptor> grpcInterceptors) throws IOException {
    ServerBuilder<?> serverBuilder = Grpc.newServerBuilderForPort(grpcPort, InsecureServerCredentials.create());
    for (BindableService service : grpcServices) {
      GrpcInterceptor annotation = service.getClass().getAnnotation(GrpcInterceptor.class);
      List<ServerInterceptor> interceptors = getAnnotatedInterceptors(annotation, grpcInterceptors);
      if (!interceptors.isEmpty()) {
        log.info("add GRPC service: {}, interceptors: {}", service, interceptors);
        serverBuilder.addService(ServerInterceptors.intercept(service, interceptors));
      } else {
        log.info("add GRPC service: {}", service);
        serverBuilder.addService(service);
      }
    }
    log.info("GRPC server start on port {}", grpcPort);
    return serverBuilder
        .directExecutor()
        .build()
        .start();
  }

  private List<ServerInterceptor> getAnnotatedInterceptors(GrpcInterceptor annotation, List<ServerInterceptor> interceptors) {
    if (annotation != null && annotation.value() != null) {
      return Arrays.stream(annotation.value())
          .flatMap(c -> interceptors.stream()
              .filter(i -> c.isInstance(i))
              .findFirst()
              .stream())
          .collect(ArrayList::new, (l, e) -> l.add(0, e), (l1, l2) -> l1.addAll(0, l2));  // collect reverse
    } else {
      return Collections.emptyList();
    }
  }
  
}
