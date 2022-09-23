import 'dart:isolate';

import 'package:query/src/platform/jobber.dart';
import 'package:query/src/common_worker.dart';

void main() {
  var j = Jobber(exampleWorkerMain, cores: numCores());
}
