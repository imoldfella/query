import 'dart:io';
import 'dart:typed_data';
import '../db/bytes.dart';
import 'dart:convert' as cnv;
import 'package:http/http.dart' as $http;
import 'io.dart'
    if (dart.library.io) 'notweb.dart'
    if (dart.library.html) 'web.dart';

export 'io.dart';

class FileReader {
  Uri url;
  FileReader(this.url) {}

  Future<int> readAt(int at, Uint8List page) async {
    final resp = await $http.get(url, headers: {
      'range': 'bytes=$at-${at + page.length}',
      'cache-control': 'no-cache',
    });
    page.setRange(0, page.length, resp.bodyBytes);
    return resp.bodyBytes.lengthInBytes;
  }
}

abstract class Writer {
  Future<int> write(Uint8List p);
}

abstract class WriteCloser extends Writer {
  Future<void> close();
}

class FsWriter implements WriteCloser {
  late IOSink sink;
  FsWriter(String path) {
    sink = File(path).openWrite();
  }

  @override
  Future<void> close() async {
    await sink.close();
  }

  @override
  Future<int> write(Uint8List p) async {
    sink.write(p);
    return p.length;
  }
}

class Fs {
  WriteCloser create(String file) {
    return FsWriter(file);
  }
}
