package io.lazybones.speeco.asr.whisper;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import io.lazybones.speeco.asr.ASR;
import io.lazybones.speeco.asr.Recognized;
import io.lazybones.speeco.common.Util;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;

@Component
@Slf4j
public class Whisper implements ASR {

  private final WebClient client;

  public Whisper(@Value("${asr.whisper.url}") String url) {
    this.client = WebClient.create(url);
  }

  @Override
  public Flux<Recognized> recognize(Flux<byte[]> audio) {
    return audio
        .buffer()
        .map(Util::mergeBytes)
        .next()
        .flatMap(mergedAudio -> {
          MultipartBodyBuilder bodyBuilder = new MultipartBodyBuilder();
          bodyBuilder.part("audio_file", new ByteArrayResource(mergedAudio))
              .contentType(MediaType.valueOf("audio/wave"))
              .filename("sample.wav");
          log.info("Send to ASR: {} bytes", mergedAudio.length);
          return client.post()
              .uri(builder -> builder
                  .path("/asr")
                  .queryParam("output", "json")
                  .build())
              .contentType(MediaType.MULTIPART_FORM_DATA)
              .body(BodyInserters.fromMultipartData(bodyBuilder.build()))
              .retrieve()
              .bodyToMono(String.class)
              .map(r -> Util.parseJson(r, WhisperResponse.class))
              .map(r -> Recognized.builder()
                  .text(r.getText())
                  .language(r.getLanguage())
                  .build());
        })
        .doOnNext(s -> log.info("Receive from ASR: {}", s))
        .flux();
  }
  
}
