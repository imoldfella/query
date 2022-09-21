import 'package:file/memory.dart';
import 'package:file/file.dart';

FileSystem getFs() {
  return MemoryFileSystem();
}

int numCores() {
  return 4;
}
