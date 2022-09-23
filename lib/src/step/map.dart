abstract class Mappable {
  map(int pos, {int assoc = 1}) {}
  MapResult mapResult(int pos, {int assoc = 1});
}

class MapResult {
  int pos;
  bool deleted;
  bool deletedBefore;
  bool deletedAfter;
  bool deletedAcross;
  MapResult({
    this.pos = 0,
    this.deleted = false,
    this.deletedBefore = false,
    this.deletedAfter = false,
    this.deletedAcross = false,
  });
}
