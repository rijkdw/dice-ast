import 'abstract_syntax_tree/ast_node.dart';
import 'abstract_syntax_tree/lexer.dart';
import 'abstract_syntax_tree/parser.dart';

void main() {
  var lexer = Lexer('3kh1ph1');
  var parser = Parser(lexer);
  var result = parser.parse();
  print(result);
  print((result as SetOpNode).getEventualChildType());
}