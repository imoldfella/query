import 'dart:isolate';
import 'dart:math';

// how can we let jobs send jobs to other threads?

class JobberPort<T> {
  // send something
  void produce(T o) {}
  // send result and then get more work.
  void complete() {}
  void error(Error e) {}
}

// we
void exampleWorkerMain(SendPort p) {
  var x = new Worker(p);
}

// probably cannot be a closure?
typedef WorkerFn = Future<void> Function(SendPort p);

class Jobber {
  static Jobber g = Jobber();
  List<Isolate> iso = [];
  final r = Random();
  SendPort get randomWorker => iso[r.nextInt(iso.length)].controlPort;

  static void start(int count, WorkerFn _worker) async {
    // this has to be shimmed to the web.
    final v = <Isolate>[];
    for (int i = 0; i < count; i++) {
      final p = ReceivePort();
      final o = await Isolate.spawn<SendPort>(_worker, p.sendPort);
      v.add(o);
    }
  }

  static void add<T, P>(
      String name, void Function(T, JobberPort<P> os) runner) {}

  static Future<List<Object?>> runAll(String name,
      {Object? Function(Object?)? monitor, List<Object?>? params}) async {
    return [];
  }

  static Future<Object?> run(String name, Object? params,
      {Object? Function(Object?)? monitor}) async {
    return null;
  }
}

// the
class JobberWaitGroup {
  void run<T>(String name,
      {Object? params, Object? Function(T)? monitor}) async {
    return null;
  }

  void wait() {}
}

class WorkPool<T> {
  Jobber j;
  String name;

  // doesn't return  anything immediately, we want this to work like a
  // hypervariable accumulating things.
  // when we are
  void run<T, Chunk>(String name, {Chunk? object}) {
    // we can pick a queue randomly.
    // we can send them a null to tell them no more.
    j.randomWorker.send(Job(name, object));
  }

  WorkPool(
    this.name, {
    Jobber? jobber,
    List<Object?>? init,
  }) : j = jobber ?? Jobber.g {
    // we need to start a hypervariable in in all the isolates that they will use to accumulate results.

    //initAll(j.next, this.name, params)
  }

  Future<List<T>> wait() async {
    // waiting involves telling all the isolates that this job is done.
    //
    return [];
  }
}
