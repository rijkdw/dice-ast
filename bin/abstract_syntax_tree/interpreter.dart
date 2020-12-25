import 'ast_node.dart';
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
      'visitSetOpNode': visitSetOpNode,
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

  dynamic visitBinOpNode(BinOpNode node) {
    visit(node.left);
    visit(node.right);
  }

  dynamic visitLiteralNode(LiteralNode node) {}

  dynamic visitUnaryOpNode(UnaryOpNode node) {
    visit(node.child);
  }

  dynamic visitSetNode(SetNode node) {
    for (var child in node.children) {
      visit(child);
    }
  }

  dynamic visitSetOpNode(SetOpNode node) {
    _debugPrint('!! Reached $node');
    var eventualChild = node.getEventualChild();
    _debugPrint('Type of eventual child is ${eventualChild.runtimeType}\n');

    // 1.  ~~The SetOpNode must be removed from the tree.~~
    // It doesn't have to be removed (it's actually quite tricky to remove it),
    // it can simply be ignored.

    // 2. Its SetOp must be given to the eventual child that isn't a SetOpNode.
    // SetOps can only be given to DiceNodes and SetNodes.
    if (eventualChild is DiceNode) {
      eventualChild.addSetOp(node.setOp);
    }
    if (eventualChild is SetNode) {
      eventualChild.addSetOp(node.setOp);
    }

    // visit child
    visit(node.child);
  }

  dynamic visitDiceNode(DiceNode node) {
    node.evaluate();
  }

  AstNode interpret() {
    var tree = parser.parse();
    visit(tree);
    return tree;
  }
}

void main() {
  var lexer = Lexer('2d20kh1e=1kh3+3');
  var parser = Parser(lexer);
  var interpreter = Interpreter(parser, verbose: true);
  var tree = interpreter.parser.parse();
  print('Tree before interpretation:\n$tree');
  interpreter.visit(tree);
  print('Tree after interpretation:\n$tree');
  print(tree.value);
}