// mapping applies to blobs
typedef BlobId = int;

// only applies to
abstract class BlobMappable {
  int map(int pos, [int? assoc = 1]);
  BlobMapResult mapResult(int pos, [int? assoc = 1]);
}

class BlobMapping {
  List<BlobStepMap> maps = [];

  BlobMapping();
}

class BlobStepMap extends BlobMappable {
  BlobStepMap();
  @override
  int map(int pos, [int? assoc = 1]) {
    return 0;
  }

  @override
  BlobMapResult mapResult(int pos, [int? assoc = 1]) {
    return BlobMapResult(pos: 0);
  }
}

class BlobMapResult {
  int pos;
  bool deleted;
  bool deletedBefore;
  bool deletedAfter;
  bool deletedAcross;
  BlobMapResult(
      {required this.pos,
      this.deleted = false,
      this.deletedBefore = false,
      this.deletedAcross = false,
      this.deletedAfter = false});
}

class Mapping {
  Map<BlobId, BlobMapping> blob = {};
}
