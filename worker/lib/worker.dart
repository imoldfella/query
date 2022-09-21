// dart2js -o web/worker.dart.js lib/src/worker.dart

@JS()
library sample;

import 'dart:html';
import 'package:js/js.dart';
import 'package:query/worker.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) {
    print('Message received from main script');
    var workerResult = 'Result: ${e.data}';
    print('Posting message back to main script');
    self.postMessage(workerResult, null);
  });
}
