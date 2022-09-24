export 'domain.dart';
import 'dart:typed_data';

import 'package:file/file.dart';

import 'map.dart';
import 'package:csv/csv.dart';
// we need to inject a file system; this file system could be encrypted

// maybe this takes a file system and implements one as well? Probably more used to retrieve file systems; this should be mostly immutable. writing is a stream of transactions. Publications are created as inserts into sys_publication

// the first thing we need is actually a publication. we need clients to be able to read publications which are static html pages, but incorporate static data structures

typedef SagaId = int;
typedef ServerId = String;

class DbId {
  String server;
  int branchId;
  DbId(this.server, this.branchId);
}

// functions allow us to code structure into the name,
typedef SagaFactory = Saga Function(String name);

class Db {
  FileSystem fs;

  Db(this.fs, {SagaFactory? saga});

  Future<void> open(String dir) async {}

  // saga's are defined by applications. They use transactions to advance or apologize
  //
  SagaId trySaga(Saga tx) {
    // we need to first apply the saga against the local database.
    // the saga may partially fail at this point
    return 0;
    // the pieces of the saga that remain need to be sent to the server, which may be off line, but we need to queue them.
  }

  // tuple ids are unique per server.
  void addTupleObserver(ServerId, TupleId, Function() onchange) {}
  // observe observes a local index.
  void addRangeObserver(TableId, Uint8List from, Uint8List to) {}

  // saga's must be deterministic. given a database state they must produce the same output.
  void receiveSaga(Saga tx) {
    // rebase any local sagas
  }

  void cancelSaga(SagaId id) {}
}

class Snapshot {}

// prosemirror transforms are sagas. prosemirror steps are transactions.
// the saga sets its own rules for the server on what context it can accept in order to be written, or reversed.
// note that prosemirror transactions are not transactions at all, because they are not atomic, they are sagas.

// needs to be extensible for custom apologies.
class Saga {
  Snapshot snapshot;
  List<Tx> steps = [];

  // we need a map set that can describe multiple blobs? should this be our Mapping though? Does each blob need its own step? that will prevent multi-blob transactions if we do. Can we talk about a server mapping of multiple blobs?
  Mapping mapping = Mapping();

  String get name => throw 'todo';

  Uint8List marshal() {
    return Uint8List(0);
  }

  void advance(Db db) {}

  // provided for the ux, this is never called by the database.
  Saga userUndo() {
    return this;
  }

  Saga(this.snapshot) {}
}

class TxMap {}

abstract class Tx {
  TxMap get map;
  TxResult apply(Snapshot snap) {
    return TxResult.ok(snap);
  }
}

class TxResult {
  Snapshot? snapshot;
  String? failed;
  TxResult({this.snapshot, this.failed});

  static TxResult ok(Snapshot s) => TxResult(snapshot: s);
  static TxResult fail(String message) => TxResult(failed: message);
}
