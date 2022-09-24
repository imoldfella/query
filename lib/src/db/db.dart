export 'domain.dart';
import 'package:file/file.dart';
import 'package:path/src/context.dart';

// we need to inject a file system; this file system could be encrypted

// maybe this takes a file system and implements one as well?

class Db implements FileSystem {
  FileSystem fs;

  Db(this.fs);

  Future<void> open(String dir) async {}

  import(String from, String to) {}

  @override
  Directory currentDirectory;

  @override
  Directory directory(path) {
    // TODO: implement directory
    throw UnimplementedError();
  }

  @override
  File file(path) {
    // TODO: implement file
    throw UnimplementedError();
  }

  @override
  String getPath(path) {
    // TODO: implement getPath
    throw UnimplementedError();
  }

  @override
  Future<bool> identical(String path1, String path2) {
    // TODO: implement identical
    throw UnimplementedError();
  }

  @override
  bool identicalSync(String path1, String path2) {
    // TODO: implement identicalSync
    throw UnimplementedError();
  }

  @override
  Future<bool> isDirectory(String path) {
    // TODO: implement isDirectory
    throw UnimplementedError();
  }

  @override
  bool isDirectorySync(String path) {
    // TODO: implement isDirectorySync
    throw UnimplementedError();
  }

  @override
  Future<bool> isFile(String path) {
    // TODO: implement isFile
    throw UnimplementedError();
  }

  @override
  bool isFileSync(String path) {
    // TODO: implement isFileSync
    throw UnimplementedError();
  }

  @override
  Future<bool> isLink(String path) {
    // TODO: implement isLink
    throw UnimplementedError();
  }

  @override
  bool isLinkSync(String path) {
    // TODO: implement isLinkSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement isWatchSupported
  bool get isWatchSupported => throw UnimplementedError();

  @override
  Link link(path) {
    // TODO: implement link
    throw UnimplementedError();
  }

  @override
  // TODO: implement path
  Context get path => throw UnimplementedError();

  @override
  Future<FileStat> stat(String path) {
    // TODO: implement stat
    throw UnimplementedError();
  }

  @override
  FileStat statSync(String path) {
    // TODO: implement statSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement systemTempDirectory
  Directory get systemTempDirectory => throw UnimplementedError();

  @override
  Future<FileSystemEntityType> type(String path, {bool followLinks = true}) {
    // TODO: implement type
    throw UnimplementedError();
  }

  @override
  FileSystemEntityType typeSync(String path, {bool followLinks = true}) {
    // TODO: implement typeSync
    throw UnimplementedError();
  }
}
