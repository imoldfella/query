@JS()
library sample;

// dart compile js -o web/worker.dart.js lib/worker.dart
import 'src/common_worker.dart';
import 'dart:html';
import 'package:js/js.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

// main thread can call terminate(), or this thread can call close()
void main() {
  final w = WorkerApp();

  self.onMessage.listen((e) {
    w.run(e.data as Job).then((r) {
      self.postMessage(r, null);
    });
  });
}
