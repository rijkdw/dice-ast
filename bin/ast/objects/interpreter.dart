import '../../utils.dart';
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
      'visitBinOp': visitBinOp,
      'visitLiteral': visitLiteral,
      'visitUnOp': visitUnOp,
      'visitSet': visitSet,
      'visitDice': visitDice,
    };
  }

  void _debugPrint(dynamic msg) {
    if (verbose) {
      print('$msg');
    }
  }

  // ------------------------------------------------------------
  // visit methods
  // ------------------------------------------------------------

  dynamic visitBinOp(BinOp node) {
    visit(node.left);
    visit(node.right);
  }

  dynamic visitLiteral(Literal node) {}

  dynamic visitUnOp(UnOp node) {
    visit(node.child);
  }

  dynamic visitSet(Set node) {
    for (var child in node.children) {
      visit(child);
    }
    node.applySetOps();
  }

  dynamic visitDice(Dice node) {
    node.roll();
    node.applySetOps();
  }

  // ------------------------------------------------------------
  // "main" method
  // ------------------------------------------------------------

  Node interpret() {
    var tree = parser.parse();
    visit(tree);
    return tree;
  }

  Node interpretTree(Node tree) {
    visit(tree);
    return tree;
  }
}

void main(List<String> args) {
  var lexer = Lexer('4d6kh3');
  var parser = Parser(lexer);
  var interpreter = Interpreter(parser);
  var tree = interpreter.interpret();
  print(prettify(tree));
}