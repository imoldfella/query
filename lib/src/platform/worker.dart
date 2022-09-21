import 'dart:isolate';

// when a worker gets a hypervariable, it holds onto it
// the jobber sends a message to stop and return the reduction.
class ReductionJob {
  int tag;
  String name;
  Object? params;
  ReductionJob(this.tag, this.name, this.params);
}

class ReductionContinue {
  int tag;
  String name;
  Object? params;
  ReductionContinue(this.tag, this.name, this.params);
}

// a regular job is done after reply
class Job {
  int tag;
  String name;
  Object? params;
  Job(this.tag, this.name, this.params);
}

typedef Registry = Map<String, Function(Job j)>;

void worker(
  SendPort p, {
  Registry? registry,
}) async {
  final sum = <int, Object?>{};

  var method = <String, Function(Job j)>{};

  if (registry != null) {}

  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);

  // Wait for messages from the main isolate.
  await for (final message in commandPort) {
    if (message is ReductionJob) {
      sum[message.tag] = message.params;
    }
  }
}

typedef WorkerFn = Future<void> Function(SendPort p);

// make your own function like this, hand this to Jobber. it needs to be global function.
// add your own methods.

