import 'ast_node.dart';
import 'nodevisitor.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  Parser parser;

  Interpreter(this.parser) {
    functionMap = {
      'visitBinOpAstNode': visitBinOpAstNode,
      'visitLiteralAstNode': visitLiteralAstNode,
      'visitUnaryOpAstNode': visitUnaryOpAstNode,
      'visitSetAstNode': visitSetAstNode,
      'visitDiceAstNode': visitDiceAstNode,
      'visitSetOpAstNode': visitSetOpAstNode,
    };
  }

  // ===========================================================================
  // VISIT NODE METHODS
  // ===========================================================================

  // TODO
  dynamic visitBinOpAstNode(BinOpAstNode node) {}

  // TODO
  dynamic visitLiteralAstNode(LiteralAstNode node) {}

  // TODO
  dynamic visitUnaryOpAstNode(UnaryOpAstNode node) {}

  // TODO
  dynamic visitSetAstNode(SetAstNode node) {}

  // TODO
  dynamic visitSetOpAstNode(SetOpAstNode node) {}

  // TODO
  dynamic visitDiceAstNode(DiceAstNode node) {}

  dynamic interpret() {
    var tree = parser.parse();
    return visit(tree);
  }
}