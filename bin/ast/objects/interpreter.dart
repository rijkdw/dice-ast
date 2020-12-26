import '../nodes/binop.dart';
import '../nodes/dice.dart';
import '../nodes/literal.dart';
import '../nodes/node.dart';
import '../nodes/set.dart';
import '../nodes/unop.dart';
import 'lexer.dart';
import 'nodevisitor.dart';
import 'parser.dart';

class Interpreter extends NodeVisitor {
  Parser parser;
  bool verbose;

  Interpreter(this.parser, {this.verbose=false}) {
    functionMap = {
      'visitBinOpNode': visitBinOpNode,
      'visitLiteralNode': visitLiteralNode,
      'visitUnaryOpNode': visitUnaryOpNode,
      'visitSetNode': visitSetNode,
      'visitDiceNode': visitDiceNode,
    };
  }

  void _debugPrint(dynamic msg) {
    if (verbose) {
      print('$msg');
    }
  }

  // ===========================================================================
  // VISIT NODE METHODS
  // ===========================================================================

  dynamic visitBinOpNode(BinOp node) {
    visit(node.left);
    visit(node.right);
  }

  dynamic visitLiteralNode(Literal node) {}

  dynamic visitUnaryOpNode(UnOp node) {
    visit(node.child);
  }

  dynamic visitSetNode(Set node) {
    for (var child in node.children) {
      visit(child);
    }
  }

  dynamic visitDiceNode(Dice node) {
    node.evaluate();
  }

  Node interpret() {
    var tree = parser.parse();
    visit(tree);
    return tree;
  }
}
