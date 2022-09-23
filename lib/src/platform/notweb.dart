import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'io.dart';
import 'package:file/local.dart' as lfs;
import 'package:file/file.dart' as fs;
import 'jobber.dart';
import 'types.dart';
import '../../isolate.dart' show worker;

int numCores() {
  return Platform.numberOfProcessors;
}

class MobileJobber extends Jobber {
  List<Isolate> iso = [];

  void send(int i, Object o) {}
  MobileJobber(this.iso);
}

Future<Jobber> getJobber() async {
  // this has to be shimmed to the web.
  final v = <Isolate>[];
  for (var i = 0; i < numCores(); i++) {
    final p = ReceivePort();
    final o = await Isolate.spawn<SendPort>(worker, p.sendPort);
    v.add(o);
  }
  return MobileJobber(v);
}

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
