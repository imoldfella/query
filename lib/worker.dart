@JS()
library sample;

// dart compile js -o web/worker.dart.js lib/worker.dart

import 'dart:html';
import 'package:js/js.dart';
import './src/platform/worker.dart';


@JS('self')
external DedicatedWorkerGlobalScope get self;

Object? _hello(Object j) { return 'world'; }

const  basicSetup = <String, Object? Function(Object j)>{
  'hello': _hello
};

class WorkerApp {
  final sum = <int, Object?>{};
  Map<String, Function(Object j)> method;
  WorkerApp(this.method);
}
// main thread can call terminate(), or this thread can call close()
void main() {

  final w = WorkerApp(basicSetup);


  // Wait for messages from the main isolate.
  await for (final message in commandPort) {
    if (message is ReductionJob) {
      sum[message.tag] = message.params;
    }
  }
}

  self.onMessage.listen((e) {
    
    print('Message received from main script');
    var workerResult = 'Result: ${e.data}';
    print('Posting message back to main script');
    self.postMessage(workerResult, null);
  });
}
