import 'dart:io';
import 'dart:typed_data';

import 'io.dart';

class FileReader implements ReadCloser {
  RandomAccessFile f;
  FileReader(this.f) {}

  @override
  void close() {
    f.close();
  }

  @override
  Future<int> read(Uint8List buffer) async {
    final a = await f.read(buffer.length);
    buffer.setRange(0, buffer.length, a);
    return a.length;
  }
}

class UrlReader {
  Future<ReadCloser> open(String url) async {
    final path = url;
    final f = await File(path).open();
    return FileReader(f);
  }
}
