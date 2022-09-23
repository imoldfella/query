import 'dart:typed_data';

// each keyed field has a v

class Db {
  Map<String, List<Uint8List>> steps = {};
}

class Step {}

class Tx {
  Db db;
  Tx(this.db);

  commit() {}
}
