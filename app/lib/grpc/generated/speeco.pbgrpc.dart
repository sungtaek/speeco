///
//  Generated code. Do not modify.
//  source: speeco.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'speeco.pb.dart' as $0;
export 'speeco.pb.dart';

class ASRClient extends $grpc.Client {
  static final _$recognize = $grpc.ClientMethod<$0.Audio, $0.Message>(
      '/speeco.ASR/recognize',
      ($0.Audio value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Message.fromBuffer(value));

  ASRClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Message> recognize($async.Stream<$0.Audio> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$recognize, request, options: options).single;
  }
}

abstract class ASRServiceBase extends $grpc.Service {
  $core.String get $name => 'speeco.ASR';

  ASRServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Audio, $0.Message>(
        'recognize',
        recognize,
        true,
        false,
        ($core.List<$core.int> value) => $0.Audio.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
  }

  $async.Future<$0.Message> recognize(
      $grpc.ServiceCall call, $async.Stream<$0.Audio> request);
}

class LLMClient extends $grpc.Client {
  static final _$create = $grpc.ClientMethod<$0.Empty, $0.Conversation>(
      '/speeco.LLM/create',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Conversation.fromBuffer(value));
  static final _$chat = $grpc.ClientMethod<$0.Message, $0.Message>(
      '/speeco.LLM/chat',
      ($0.Message value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Message.fromBuffer(value));

  LLMClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Conversation> create($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseStream<$0.Message> chat($0.Message request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$chat, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class LLMServiceBase extends $grpc.Service {
  $core.String get $name => 'speeco.LLM';

  LLMServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Conversation>(
        'create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Conversation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Message>(
        'chat',
        chat_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
  }

  $async.Future<$0.Conversation> create_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return create(call, await request);
  }

  $async.Stream<$0.Message> chat_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Message> request) async* {
    yield* chat(call, await request);
  }

  $async.Future<$0.Conversation> create(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.Message> chat($grpc.ServiceCall call, $0.Message request);
}

class TTSClient extends $grpc.Client {
  static final _$convert = $grpc.ClientMethod<$0.Message, $0.Audio>(
      '/speeco.TTS/convert',
      ($0.Message value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Audio.fromBuffer(value));

  TTSClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Audio> convert($0.Message request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$convert, request, options: options);
  }
}

abstract class TTSServiceBase extends $grpc.Service {
  $core.String get $name => 'speeco.TTS';

  TTSServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Audio>(
        'convert',
        convert_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Audio value) => value.writeToBuffer()));
  }

  $async.Future<$0.Audio> convert_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Message> request) async {
    return convert(call, await request);
  }

  $async.Future<$0.Audio> convert($grpc.ServiceCall call, $0.Message request);
}
