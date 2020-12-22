import 'node.dart';
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
    };
  }

  // ===========================================================================
  // VISIT NODE METHODS
  // ===========================================================================

  // TODO
  dynamic visitBinOpNode(BinOpNode node) {}

  // TODO
  dynamic visitLiteralNode(BinOpNode node) {}

  // TODO
  dynamic visitUnaryOpNode(BinOpNode node) {}

  // TODO
  dynamic visitSetNode(BinOpNode node) {}

  // TODO
  dynamic visitDiceNode(BinOpNode node) {}

  dynamic interpret() {
    var tree = parser.parse();
    return visit(tree);
  }
}