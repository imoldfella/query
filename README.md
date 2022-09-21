# this is a search engine for datagrove.
The query parser is forked from https://github.com/isoos/query


Supported expressions:

- (Implicit) boolean AND: `a AND b` or `a b`
- boolean OR: `a OR b OR c`
- boolean NOT: `-a` or `NOT a`
- group query: `(a b) OR (c d)`
- text match: `abc` or `"words in close proximity"`
- range query: `[1 TO 20]` (inclusive), `]aaa TO dzz[` (exclusive), or `[1 TO 20[` (mixed)
- scopes: `field:(a b)` or `field:abc`
- field comparison: `year < 2000`

## Usage

A simple usage example:

```dart
import 'package:query/query.dart';


dart2js --minify -o=app.dart.js app.dart




main() {
  final q = parseQuery('some text OR field:another');
  // prints "(some (text OR field:another))"
  print(q);
}
```
