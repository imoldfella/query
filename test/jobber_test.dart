

import 'dart:isolate';

import 'package:query/src/platform/jobber.dart';
import 'package:query/src/platform/worker.dart';

// for web this must 
void exampleWorkerMain(SendPort p) {

  worker(p, registry: {
    "hello": (Object? o)  {
      return "world";
    }
  });
}

void webLibraryMain() {
  window.onmessage = ( ){
  }
}


void main() {

  var j = Jobber(exampleWorkerMain, cores: numCores());

}

