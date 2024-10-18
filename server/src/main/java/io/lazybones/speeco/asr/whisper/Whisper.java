package io.lazybones.speeco.asr.whisper;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

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
import reactor.core.publisher.Mono;

@Component
@Slf4j
public class Whisper implements ASR {

  private final WebClient client;

  public Whisper(@Value("${asr.whisper.url}") String url) {
    this.client = WebClient.create(url);
  }

  @Override
  public Mono<Recognized> recognize(Flux<byte[]> audio) {
    return audio
        .buffer()
        .map(Util::mergeBytes)
        .next()
        .flatMap(mergedAudio -> {
          MultipartBodyBuilder bodyBuilder = new MultipartBodyBuilder();
          ByteArrayOutputStream bodyOutputStream = new ByteArrayOutputStream();
          writeAsWave(bodyOutputStream, 1, 16000, 16, mergedAudio);
          byte[] wave = bodyOutputStream.toByteArray();
          try (FileOutputStream waveFile = new FileOutputStream("./test.wav")) {
            waveFile.write(wave);
          } catch (Exception ex) {
            ex.printStackTrace();
          }
          bodyBuilder.part("audio_file", new ByteArrayResource(wave))
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
        .doOnNext(s -> log.info("Receive from ASR: {}", s));
  }

  private void writeAsWave(OutputStream output, int channelCount, int sampleRate, int bitsPerSample, byte[] data) {
    try {
      // WAVE RIFF header
      writeToOutput(output, "RIFF"); // chunk id
      writeToOutput(output, 36 + data.length); // chunk size
      writeToOutput(output, "WAVE"); // format

      // SUB CHUNK 1 (FORMAT)
      writeToOutput(output, "fmt "); // subchunk 1 id
      writeToOutput(output, 16); // subchunk 1 size
      writeToOutput(output, (short) 1); // audio format (1 = PCM)
      writeToOutput(output, (short) channelCount); // number of channelCount
      writeToOutput(output, sampleRate); // sample rate
      writeToOutput(output, sampleRate * channelCount * bitsPerSample / 8); // byte rate
      writeToOutput(output, (short) (channelCount * bitsPerSample / 8)); // block align
      writeToOutput(output, (short) bitsPerSample); // bits per sample

      // SUB CHUNK 2 (AUDIO DATA)
      writeToOutput(output, "data"); // subchunk 2 id
      writeToOutput(output, data.length); // subchunk 2 size
      writeToOutput(output, data); // audio data
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  private void writeToOutput(OutputStream output, String data) throws IOException {
    for (int i = 0; i < data.length(); i++)
      output.write(data.charAt(i));
  }

  private void writeToOutput(OutputStream output, int data) throws IOException {
    output.write(data >> 0);
    output.write(data >> 8);
    output.write(data >> 16);
    output.write(data >> 24);
  }

  private void writeToOutput(OutputStream output, short data) throws IOException {
    output.write(data >> 0);
    output.write(data >> 8);
  }

  private void writeToOutput(OutputStream output, byte[] data) throws IOException {
    output.write(data, 0, data.length);
  }

}
