///
//  Generated code. Do not modify.
//  source: speeco.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use ownerDescriptor instead')
const Owner$json = const {
  '1': 'Owner',
  '2': const [
    const {'1': 'USER', '2': 0},
    const {'1': 'COACH', '2': 1},
  ],
};

/// Descriptor for `Owner`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ownerDescriptor = $convert.base64Decode('CgVPd25lchIICgRVU0VSEAASCQoFQ09BQ0gQAQ==');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use audioDescriptor instead')
const Audio$json = const {
  '1': 'Audio',
  '2': const [
    const {'1': 'pcm', '3': 1, '4': 1, '5': 12, '10': 'pcm'},
  ],
};

/// Descriptor for `Audio`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioDescriptor = $convert.base64Decode('CgVBdWRpbxIQCgNwY20YASABKAxSA3BjbQ==');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'owner', '3': 1, '4': 1, '5': 14, '6': '.speeco.Owner', '10': 'owner'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEiMKBW93bmVyGAEgASgOMg0uc3BlZWNvLk93bmVyUgVvd25lchISCgR0ZXh0GAIgASgJUgR0ZXh0');
@$core.Deprecated('Use conversationDescriptor instead')
const Conversation$json = const {
  '1': 'Conversation',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
    const {'1': 'coach', '3': 3, '4': 1, '5': 9, '10': 'coach'},
    const {'1': 'messages', '3': 4, '4': 3, '5': 11, '6': '.speeco.Message', '10': 'messages'},
  ],
};

/// Descriptor for `Conversation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationDescriptor = $convert.base64Decode('CgxDb252ZXJzYXRpb24SDgoCaWQYASABKAlSAmlkEhIKBHVzZXIYAiABKAlSBHVzZXISFAoFY29hY2gYAyABKAlSBWNvYWNoEisKCG1lc3NhZ2VzGAQgAygLMg8uc3BlZWNvLk1lc3NhZ2VSCG1lc3NhZ2Vz');
