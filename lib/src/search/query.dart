import 'ast.dart';
import 'grammar.dart';

export 'ast.dart';

final _parser = QueryGrammarDefinition().build<Query>();

/// Parses [input] and returns a parsed [Query].
Query parseQuery(String input) {
  return _parser.parse(input).value;
}
