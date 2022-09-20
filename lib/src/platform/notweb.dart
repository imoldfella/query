import 'dart:io';
import 'dart:typed_data';

import 'io.dart';
import 'package:file/local.dart' as lfs;
import 'package:file/file.dart' as fs;
import 'types.dart';

fs.FileSystem getFs() {
  return const lfs.LocalFileSystem();
}

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
