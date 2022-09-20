import 'dart:typed_data';

abstract class ReadCloser {
  Future<int> read(Uint8List buffer);
  void close();
}
