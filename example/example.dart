import 'package:query/query.dart';

void main() {
  final Query q = parseQuery('some text OR field:another');
  // prints "(some (text OR field:another))"
  print(q);
}
