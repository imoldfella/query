import 'dart:async';

import '../platform/platform.dart';
import 'package:file/file.dart';

// jobber is initialized differently in worker, need to respect that.
// maybe output is a branch? a special kind of fs?

// we should collect the postings per thread, not return and merge them.
// this requires jobber to create a sink.
void workerMain() {
  FileAnalyzer.registerInWorker();
}

// this is only for one document, so only a list of terms.
class PostingList {
  int index;
  List<String> terms;
  PostingList(this.index, this.terms);
}

class FileInput {
  int docid;
  FileSystemEntity fe;
  FileInput(this.docid, this.fe);
}

// this is what we will launch, run once per isolate.

typedef Analyzer = Function(FileInput fe, JobberPort<PostingList> os);

class FileAnalyzer {
  final all = <String, List<Analyzer>>{};
  void add(String ext, Analyzer a) {
    var o = all[ext];
    if (o == null) {
      all[ext] = [a];
    } else {
      o.add(a);
    }
  }

  FileAnalyser() {
    // add("csv", _csv);

    // Jobber.add('importFile', (FileSystemEntity fe, JobberPort<PostingList> os) {
    //   os
    //     ..produce(PostingList(
    //       0,
    //     ))
    //     ..complete();
    // });
  }

  static FileAnalyzer? g;
  static void registerInWorker() {
    g = FileAnalyzer();
  }

  static import(Directory input, Directory output) async {
    final wg = JobberWaitGroup();

    void monitor(PostingList o) {
      // process posting lists coming back from the wait group.
    }

    final fs = input.list(recursive: true, followLinks: true);
    await for (final fe in fs) {
      // if monitor is optional, we can't really have a type for it?
      wg.run<PostingList>('importFile', params: fe, monitor: monitor);
    }
    wg.wait();
  }
}

_csv(FileSystemEntity fe, JobberPort<PostingList> os) {}





/*


class 
void registerAnalyser(String extension, Function(FileSystemEntity) parse) {


}
void registerImports() {
  regis

}


void bulkImport(Directory input, Fs output) async {

}
*/