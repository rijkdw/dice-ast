import 'abstract_syntax_tree/lexer.dart';
import 'abstract_syntax_tree/parser.dart';

void main() {
  var lexer = Lexer('3+(3*2)+1d4');
  var parser = Parser(lexer);
  var result = parser.parse().value;
  print(result);
}