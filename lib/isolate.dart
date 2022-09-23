import 'dart:isolate';
import 'src/common_worker.dart';

void worker(SendPort p) async {
  final w = WorkerApp();

  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);

  // Wait for messages from the main isolate.
  await for (final message in commandPort) {
    p.send(w.run(message as Job));
  }
}
