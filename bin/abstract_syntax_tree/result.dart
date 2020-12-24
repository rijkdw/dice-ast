import 'ast_node.dart';
import 'die.dart';

/// A wrapper class for any [AstNode] that is the root of a tree.
/// Enables obtaining of dice total, kept and ignored dice, etc
class Result {

  String expr;
  AstNode rootNode;

  Result(this.expr, this.rootNode);

  int get total => rootNode.value;

  AstNode get tree {
    return rootNode;
  }

  List<Die> get die => rootNode.die;

  @override
  String toString() => 'Result(expr=$expr, tree=$tree)';

}

class DiceResult {

}