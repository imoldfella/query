// we should allow this to run in an isolate and send messages to ui thread.
// does it make sense to use websockets in debugging?

import '../search/query.dart';

import 'index.dart';

abstract class FileSystem {}

typedef Listener = Function();

// the network connection can be stored in the file system so really we just
// need access to a encypted file system.

// parse the query and build the nodes that we need to compute the tuples that match the query.  index.field: x to y can give us a range search.

class Db {
  FileSystem fs;
  Db(this.fs);

  // the application is going set watches as it goes what is the api for that?

  void observe(int tag, String q) {
    final qr = parseQuery(q);
    if (qr is TextQuery) {}
  }

  Set<Listener> listener = {};

  static Future<Db> open(FileSystem fs) async {
    final r = Db(fs);
    return r;
  }

  final index = IndexWriter();

  // we can watch the index from the user interface based on the what the user is looking at to notify of changes. We want to notify all at once though, not every tuple.
  write(Index i, Tuple o) {
    //
  }
  commit(List<Tuple> t) {
    for (final o in t) {
      for (final i in o.table.index) {
        write(i, o);
      }
    }

    // trigger the nodes that we built up.
    for (final o in listener) {
      o();
    }
  }
}
