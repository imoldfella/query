import 'package:file/file.dart';
import 'dart:typed_data';
import '../db/bytes.dart';
import 'dart:convert' as cnv;
import 'package:http/http.dart' as $http;
import 'io.dart'
    if (dart.library.io) 'notweb.dart'
    if (dart.library.html) 'web.dart';

export 'io.dart';
export 'types.dart';
export 'jobber.dart';

class Fs {
  late FileSystem fs;
  Fs() {
    fs = getFs();
  }

  Future<Uint8List> read(Uri url) async {
    final resp = await $http.get(url);
    return resp.bodyBytes;
  }

  Future<Uint8List> readAt(Uri url, int at, int size) async {
    final resp = await $http.get(url, headers: {
      'range': 'bytes=$at-${at + size}',
      'cache-control': 'no-cache',
    });
    return resp.bodyBytes;
  }
}
