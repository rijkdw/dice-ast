import 'ast_node.dart';
import 'nodevisitor.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  Parser parser;

  Interpreter(this.parser) {
    functionMap = {
      'visitBinOpNode': visitBinOpNode,
      'visitLiteralNode': visitLiteralNode,
      'visitUnaryOpNode': visitUnaryOpNode,
      'visitSetNode': visitSetNode,
      'visitDiceNode': visitDiceNode,
      'visitSetOpNode': visitSetOpNode,
    };
  }

  // ===========================================================================
  // VISIT NODE METHODS
  // ===========================================================================

  // TODO
  dynamic visitBinOpNode(BinOpNode node) {}

  // TODO
  dynamic visitLiteralNode(LiteralNode node) {}

  // TODO
  dynamic visitUnaryOpNode(UnaryOpNode node) {}

  // TODO
  dynamic visitSetNode(SetNode node) {}

  // TODO
  dynamic visitSetOpNode(SetOpNode node) {}

  // TODO
  dynamic visitDiceNode(DiceNode node) {}

  dynamic interpret() {
    var tree = parser.parse();
    return visit(tree);
  }
}