// posting = document, position
import 'dart:collection';
import 'dart:typed_data';

// index writer requires a file system of some kind
class IndexWriter {

  
  // we could cache this in memory for a while to read directly.
  void add(Batch b) {

  }
}

// we don't need the id because we store the entire document?
// do we want to do that? concatenating documents gives us more documents in a site under 20K limit.

// we can easily create batches in isolates. we can write them to file and merge
class PostingList {
  List<int> doc = [];
  Uint8List weight = Uint8List(0);
  void add(int d, int w) {
    doc.add(d);
    weight.add(w);
  }
}

class Batch {
  ReadWriteCloser f;
  IndexWriter w;
  // possible improvements here would be to use utf8, maybe use Hope encoding or FSST. FSST is not ordered but does have equality.
  final posting = <String, PostingList>{};
  int next = 0;

  Batch(this.w);

  void doc(Uint8List doc) {
    next++;
  }

  void add(String term, int weight) {
    var l = posting[term];
    if (l == null) {
      l = PostingList();
      posting[term] = l;
    }
    l.add(next, weight);
  }

  void commit() {
    // sort the posting list and write to the file.
    final entries = posting.entries.toList();
    entries.sort();
    for (final o in entries){
      o.key
      o.value
    }


    // close the file and add it to the IndexWriter.
  }
}

// compressing the weights is hard because they are not sorted. instead
// we can drop the resolution, even 0-255 is a lot of gradations.

  // term can just be a path that we store prefix truncated in the btree

