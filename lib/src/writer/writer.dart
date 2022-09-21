// posting = document, position
import 'dart:collection';
import 'dart:isolate';
import 'dart:typed_data';

import '../db/db.dart';
import '../platform/platform.dart';

// index writer requires a file system of some kind
class IndexWriter {
  // we could cache this in memory for a while to read directly.
  void add(Batch b) {}
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
  //ReadWriteCloser f;
  IndexWriter w;
  // possible improvements here would be to use utf8, maybe use Hope encoding or FSST. FSST is not ordered but does have equality.
  final posting = <String, PostingList>{};
  int next = 0;

  int create(String path) {
    return next++;
  }

  Batch(this.w);

  void commit() {
    // sort the posting list and write to the file.
    final entries = posting.entries.toList();
    entries.sort();
    for (final o in entries) {
      // o.key
      // o.value
    }

    // close the file and add it to the IndexWriter.
  }
}

// Steps are database "saga", but DocSaga doesn't sound as good as DocStep
/*
class Step {
  Batch b;
  int id;
  Step(this.b,this.id);

    void addx(Domain f, int weight) {
    var l = posting[term];
    if (l == null) {
      l = PostingList();
      posting[term] = l;
    }
    l.add(next, weight);
  }
}
// send back pieces of the 
class BatchPort {
  add()
}

*/


// compressing the weights is hard because they are not sorted. instead
// we can drop the resolution, even 0-255 is a lot of gradations.

  // term can just be a path that we store prefix truncated in the btree


// DocStep is a general irrevocable addition of documents from a directory tree for publishing 

// these need to be oli-tons; singletons but one per isolate.
// there is no way to share even immutable resources in dart.
// https://github.com/dart-lang/language/issues/124
// https://github.com/dart-lang/sdk/issues/32953
// constants can be shared, strings are shared.
// the best approach for now is to generate this information as dart const
// in that case

// to spawn, the parser must be a function
// the function can use a generated const 
// Isolate.spawn( _parseJob, p.sendPort) {

// }

/*
abstract class Parser {
  void parse(DocStepWriter w, ReadCloser f);

}
class CsvParser extends Parser{

}
class DefaultParser extends Parser {

}
  static final fileType = <String, List<Parser>>{
    'csv': [
      CsvParser(),
    ],
    '*': [
      DefaultParser(),
    ]
  };
*/

// no isolates in dart2js though? so some abstraction is necessary
// typedef Parser = Function(SendPort p);
// typedef Parser2 = Function(DocStepWriter w, ReadCloser f);


// each parser is a job. we can pass it the path and let it open the file itself

// { world, branch, path}?

// the job has to provide a tag to send back the data to the correct port
// potentially we could use file locks? hard to imagine that's faster though.
//ypedef Parser =  Function(String url, BatchPort p);

// on mobile

// on web


/*
class DocStepWriter extends Step {


  DocStepWriter(super.b,super.id);

  void add(String path, ReadCloser file ){
    
  }

}

class DocStep {
  static DocStepWriter  create(Batch b, String branchPath) {
    return DocStepWriter(b,b.create(branchPath));
  }
}
*/
