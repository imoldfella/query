import 'dart:typed_data';

abstract class ReadCloser {
  Future<int> read(Uint8List buffer);
  void close();
}

abstract class Writer {
  Future<int> write(Uint8List p);
}

abstract class WriteCloser extends Writer {
  Future<void> close();
}
