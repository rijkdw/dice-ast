import '../abstract_syntax_tree/ast_node.dart';
import 'cot_node.dart';

class LiteralCotNode extends CotNode {

  num value;

  LiteralCotNode(this.value);

  factory LiteralCotNode.fromLiteralAstNode(LiteralNode node) {
    return LiteralCotNode(node.literalValue);
  }

  @override
  int get total => value;

}