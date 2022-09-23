// operations on  a protobuf sequence

import 'dart:typed_data';

import 'data.dart' as proto;
import 'tx.dart';

class Sequence {
  List<double> id;
  double next;
  Uint8List key;
  Sequence(this.key, this.id, this.next);

  static Sequence create(Tx tx, Uint8List key, int count) {
    return Sequence(key, List<double>.generate(count, (e) => e.toDouble()),
        count.toDouble());
  }

  static Sequence load(Uint8List key, Uint8List bytes) {
    final o = proto.Sequence.fromBuffer(bytes);

    return Sequence(key, o.id, o.next);
  }

  void replace(int start, int end, List<double> id) {
    id.removeRange(start, end);
    id.insertAll(start, id);
  }

  void insertBefore(int start, int count) {}
  void delete(int start, int count) {}
  void move(int start, int count, int before) {}
}

void test() {}
