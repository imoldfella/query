import 'dart:io';
import 'dart:typed_data';

import '../platform/platform.dart';
import 'package:archive/archive_io.dart';

// mostly we are indexing files in a directory, but we also want to index csv's by row as if each row is a document. or maybe a yaml that lists the csv's
// schema because two attributes could have the same name, but not really be the same field.

// we need to be able to split the output into fixed lengths to accomodate static host limitations.
// in the end we need to:
// 1. assign every document an id and create a giant document vector
// 2. create an inverted index to all the terms
// we want to do more analysis on the documents that we download.


class IndexNode {
  List<Uint8List> key = [];
  List<int> pointer=[];
  int size=0;

  void clear(){
    key=[];
    pointer= [];
    size=0;
  }
  Uint8List toBytes() {
    final b = BytesBuilder();
    
    return b.toBytes();
  }
  int add(Uint8List k, int p) {
    key.add(k);
    pointer.add(p);
    size += k.length + 8;
    return size;
  }
}

// we can make the root of the index its own file, that way we don't need to know its length. we can write the other interior blocks as we fill them up.
class CompressedWriter {
  Fs output;
  var buffer = Uint8List(0);
  int tellp = 0; // where we will write the next bytes
  ReadCloser input;
  int pageSize = 64 * 1024;
  int fileSize = 2 ^ 53 - 1;
  int remain = 0;
  WriteCloser? writer;
  int nextFile = 0;

  CompressedWriter(
      {required this.input,
      required this.output,
      this.pageSize = 64 * 1024,
      int fileSize = 2 ^ 53 - 1});

  List<IndexNode> stack = [];
  void add(Uint8List line, int level, int pointer) {
    // we only care about the key
    final key = line.sublist(0, line.indexOf(124));
    if (stack[level].add(key,pointer)>pageSize) {
      if (level+1==stack.length ){
        stack.add(IndexNode());
      }
      // write the node
      add(stack[level].key[0],level+1, ptr);

      stack[level].clear();
    }
    
  }

  int write(Uint8List data) {
    if (remain < data.length){
      writer = output.create("Data$nextFile"); 
      remain = fileSize;
      nextFile += fileSize;
    }
    writer!.write(data);

    final pos = fileSize - remain;
    remain -= data.length;
    return pos;
  }
  Future<void> build() async {
    final buffer = Uint8List(pageSize);
    final z = ZLibEncoder();
    var left = Uint8List(0);

    // we need a stack of Index nodes that we are building
    //
    stack = [IndexNode()];

    while (true) {
      var b = BytesBuilder();
      if (left.isNotEmpty) {
        b.add(left);
      }
      final n = await input.read(buffer);
      if (n == buffer.length) {
        final pos = buffer.lastIndexOf(10);
        left = buffer.sublist(pos + 1);
        b.add(buffer.sublist(0, pos));
      }
      final nd = b.toBytes();
      
      final compressed = Uint8List.fromList(z.encode(nd));
      b.clear();
      final ptr = write(compressed);
      add(nd, 0, ptr);


      // if there is not enough room, start a new file
      // logically pad the file per the pointers.

      // we need to find any partial lines and save them for next page

      // copy the remaining bytes to the beginning of the buffer

    
    while (n == pageSize) {

    }
  }

  var compressTo = Uint8List(64 * 1024);
}

// Pack the leaves first, (dart compression?) then write the index nodes.

//
