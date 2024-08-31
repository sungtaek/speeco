package io.lazybones.speeco.tts.opentts;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;

import io.lazybones.speeco.tts.TTS;
import reactor.core.publisher.Mono;

@Component
public class OpenTTS implements TTS {

  private final WebClient client;

  public OpenTTS(@Value("${tts.open-tts.url}") String url) {
    this.client = WebClient.builder()
        .baseUrl(url)
        .exchangeStrategies(ExchangeStrategies.builder()
            .codecs(configure -> configure.defaultCodecs().maxInMemorySize(-1))
            .build())
        .build();
  }

  @Override
  public List<String> getVoices() {
    return List.of();
  }

  @Override
  public Mono<byte[]> tts(String voice, String text) {
    return client.get()
        .uri(builder -> builder
            .path("/api/tts")
            .queryParam("voice", voice)
            .queryParam("text", text)
            .build())
        .retrieve()
        .bodyToMono(byte[].class);
  }
  
}
