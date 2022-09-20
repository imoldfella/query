import 'dart:math';

import 'dart:typed_data';

class Bytes implements Comparable {
  late Uint8List data;
  static final empty = Bytes(Uint8List(0));

  Bytes(this.data);

  @override
  int get hashCode => 0;
  @override
  bool operator ==(Object other) =>
      other is Bytes && listEquals(data, other.data);

  Bytes operator +(Bytes b) => Bytes(Uint8List.fromList([...data, ...b.data]));

  @override
  int compareTo(other) {
    return compareBytes(data, (other as Bytes).data);
  }
}

int compareBytes(Uint8List data, Uint8List b) {
  int m = min(b.length, data.length);
  for (var i = 0; i < m; i++) {
    final ix = data[i].compareTo(b[i]);
    if (ix != 0) {
      return ix;
    }
  }
  return data.length < b.length ? -1 : (data.length == b.length ? 0 : 1);
}

bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}
