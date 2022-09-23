///
//  Generated code. Do not modify.
//  source: sequence.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sequenceDescriptor instead')
const Sequence$json = const {
  '1': 'Sequence',
  '2': const [
    const {'1': 'id', '3': 1, '4': 3, '5': 1, '10': 'id'},
    const {'1': 'next', '3': 2, '4': 1, '5': 1, '10': 'next'},
  ],
};

/// Descriptor for `Sequence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sequenceDescriptor = $convert.base64Decode('CghTZXF1ZW5jZRIOCgJpZBgBIAMoAVICaWQSEgoEbmV4dBgCIAEoAVIEbmV4dA==');
@$core.Deprecated('Use sequenceStepDescriptor instead')
const SequenceStep$json = const {
  '1': 'SequenceStep',
  '2': const [
    const {'1': 'start', '3': 1, '4': 1, '5': 5, '10': 'start'},
    const {'1': 'end', '3': 2, '4': 1, '5': 5, '10': 'end'},
    const {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `SequenceStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sequenceStepDescriptor = $convert.base64Decode('CgxTZXF1ZW5jZVN0ZXASFAoFc3RhcnQYASABKAVSBXN0YXJ0EhAKA2VuZBgCIAEoBVIDZW5kEhQKBWNvdW50GAMgASgFUgVjb3VudA==');
