import 'dart:typed_data';
import 'dart:collection';
import 'dart:io';

// documents: markdown, spreadsheet, chat, datatable,

class TableDesc {}

class IndexDesc {}

class RangeDesc {
  bool match(Tuple t) => true;
}

class Tuple {
  Table table;
  Tuple(this.table);
}

abstract class ReadCloser {
  Future<Uint8List> read(int at, int count);
  void close();
}

class FileReader implements ReadCloser {
  RandomAccessFile f;
  FileReader(this.f) {}

  @override
  void close() {
    f.close();
  }

  @override
  Future<Uint8List> read(int at, int count) async {
    await f.setPosition(at);
    return f.read(count);
  }
}

class UrlReader {
  Future<ReadCloser> open(String url) async {
    final path = url;
    final f = await File(path).open();
    return FileReader(f);
  }
}

// posting = document, position
class IndexWriter {
  final unique = SplayTreeMap<Uint8List, Uint8List>();
  final posting = Map<String, List<int>>();
  commit(List<Tuple> tuple) {}
}

class IndexReader {
  ReadCloser read;
  IndexReader(this.read) {}
}

class IndexMerger {
  static merge(String path1, String path2) {}
}

class Table {
  List<Index> index = [];
}

class Index {
  List<RangeDesc> active = [];
  write(IndexWriter w, Tuple t) {
    for (final o in active) {
      if (o.match(t)) {}
    }
  }
}

// we probably stay logged in locally but
// we need to do the authorization outside and pass in the file system and network connection
