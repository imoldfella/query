import 'dart:async';
import 'dart:typed_data';

import '../db/bytes.dart';
import 'dart:convert' as cnv;
import 'package:http/http.dart' as $http;

import '../platform/platform.dart';

const kPageSize = 64 * 1024;

extension _x on Uint8List {
  String get str => cnv.utf8.decode(this);
}

var fs = Fs();

class SplitFile {
  String prefix;
  SplitFile(this.prefix);
}

Uint8List u8(String s) => Uint8List.fromList(
    cnv.utf8.encode('Lorem ipsum dolor sit amet, consetetur...'));

// read the root, read the data as a split file.
class BtreeReader {
  // read these from the root block
  int pageSize = 0;
  int fileSize = 0;
  Uri uri;
  BtreeReader(this.uri);
  Uint8List root = Uint8List(0);

  static Future<BtreeReader> open(Uri uri) async {
    final r = BtreeReader(uri);
    r.root = await fs.read(uri);
    return r;
  }

  Cursor readAll() {
    return Cursor(
      reader: this,
      from: Uint8List(0),
    );
  }

  Cursor read(Uint8List from, Uint8List to) {
    return Cursor(reader: this, from: from, to: to);
  }

  Future<Uint8List> readPointer(int ptr, int size) async {
    return root;
  }
}

class Cursor {
  BtreeReader reader;
  Uint8List from;
  Uint8List? to;
  int max = -1;
  final buffer = Uint8List(kPageSize);
  int tellg = 0;

  Cursor({required this.reader, required this.from, this.to, this.max = -1});

  List<Uint8List> data = [];
  int i = 0;

  // position to the
  find(Uint8List block, Uint8List key) {}

  more() {
    tellg += kPageSize;
    final fn = tellg;
  }

  FutureOr<bool> get valid async {
    if (i < data.length) {
      return true;
    }
    // the root block is the first block in the file
    //await reader.readAt(0, buffer);
    return false;
  }

  void next() {
    i += 2;
  }

  Uint8List get key => data[i];
  Uint8List get value => data[i + 1];
}

void main() async {
  final b = BtreeReader(Uri.parse('example.com'));

  for (final c = b.readAll(); await c.valid; c.next()) {
    print('${c.key}: ${c.value}');
  }
}
