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

// make your own function like this, hand this to Jobber. it needs to be global function.
// add your own methods.

Object? _hello(Object j) {
  return 'world';
}

const basicSetup = <String, Object? Function(Object j)>{'hello': _hello};

class WorkerApp {
  final sum = <int, Object?>{};
  Map<String, Function(Object j)> method;
  WorkerApp({this.method = basicSetup});

  Future<Object> run(Job j) async {
    return j;
  }
}
