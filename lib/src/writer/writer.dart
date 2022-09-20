// posting = document, position
import 'dart:collection';
import 'dart:typed_data';

// index writer requires a file system of some kind
class IndexWriter {
  final unique = SplayTreeMap<Uint8List, Uint8List>();
  final posting = Map<String, List<int>>();
}
