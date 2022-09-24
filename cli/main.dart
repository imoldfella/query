import 'dart:async';
import 'dart:io';

import 'package:query/client.dart';
import 'package:file/file.dart';
// a web program requires linking this package and also this package compiled as a web worker.
import 'package:dcli/dcli.dart';
import 'package:args/command_runner.dart';
// first argument should be the directory defaulting to current.

late Db db;
Future<int> main(List<String> args) async {
  final fs = getFs();
  db = Db(fs);

  final runner = CommandRunner<int>('draw', 'Draws shapes')
    ..addCommand(Import());
  runner.argParser.addOption('home',
      abbr: 'h',
      help: 'database directory',
      defaultsTo: (homeDirectory() ?? '') + '/datagrove');

  final output = await runner.run(args);
  return output ?? 0;
}

Future<void> init(ArgParser a) async {
  final home = a.options['h']!;
  await db.open(home.toString());
}

class Import extends Command<int> {
  @override
  FutureOr<int>? run() async {
    await init(argParser);
    return 0;
  }

  @override
  String get description => 'import files';

  @override
  String get name => 'import';
}

class Export extends Command<int> {
  @override
  String get description => 'export files';

  @override
  String get name => 'export';
}

class Watch extends Command<int> {
  Watch() {
    argParser.addOption('size', help: 'Size of the square');
  }
  @override
  String get description => 'watch files';

  @override
  String get name => 'watch';
  @override
  FutureOr<int>? run() {
    return 0;
  }
}

// Get the home directory or null if unknown.
String? homeDirectory() {
  switch (Platform.operatingSystem) {
    case 'linux':
    case 'macos':
      return Platform.environment['HOME'];
    case 'windows':
      return Platform.environment['USERPROFILE'];
    case 'android':
      // Probably want internal storage.
      return '/storage/sdcard0';
    case 'ios':
      // iOS doesn't really have a home directory.
      return null;
    case 'fuchsia':
      // I have no idea.
      return null;
    default:
      return null;
  }
}
