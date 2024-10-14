///
//  Generated code. Do not modify.
//  source: speeco.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
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
    const {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEhIKBHRleHQYASABKAlSBHRleHQ=');
