import 'dart:convert';

import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:csv/csv.dart';

import 'writer.dart';

abstract class Cancelable {
  double progress = 0;
  Future<void> cancel();
}

class Publish extends Cancelable {
  FileSystem src;
  FileSystem target;

  Publish(this.src, this.target);

  @override
  Future<void> cancel() async {}

  Future<Publish> start(FileSystem src, FileSystem target) async {
    return Publish(this.src, this.target);
  }
}

// get all the files so we can build them in parallel.
class FileSet {
  late List<File> file;

  static Future<List<FileSystemEntity>> glob(Directory dir, String glob) async {
    final g = Glob(glob);
    final f = await dir.list().toList();

    return f.where((e) => (e is File && g.matches(e.basename))).toList();
  }
}

class BuildRule {}

Stream<List<dynamic>> csvStream(File f) {
  final csvFile = f.openRead();
  return csvFile.transform(utf8.decoder).transform(
        CsvToListConverter(),
      );
}

// An index writer stores tuples/documents per lucene

// split searchable records into geographic areas.
// we should probably search on zip code
class GeoWriter {
  IndexWriter w;
  GeoWriter(this.w);
  writeAddress(Address a) {}
  writeLatLong() {}
}

Future<void> geocode(File f, GeoWriter w) async {
  await for (final o in csvStream(f)) {}
}

// roughly a file system.
// we need to decorate with pretty names
// we need to reuse files that haven't changed.
// we might need to pack files into bigger files.
// seo implies public, so maybe take advantage of that.
// in general we should try to put files other than index into standalone files
// the service worker already needs to name them though, why not look them up in ranges?
//

// service worker will be called from a context of db-branch.server.com
// so it can only fetch from that. It can resolve the path to a hash id.
// note that when used by muggle we don't get access to multiple databases

//
// class ServiceWorker {
//   String pathToHash(String path) {
//     return path;
//   }

//   fetch(String url) {

//   }
//   search(Query ){

//   }
// }
