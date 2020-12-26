import '../nodes/node.dart';
import '../nodes/die.dart';

/// A wrapper class for any [Node] that is the root of a tree.
/// Enables obtaining of dice total, kept and ignored dice, etc
class Result {

  String expr;
  Node rootNode;

  Result(this.expr, this.rootNode);

  int get total => rootNode.value;

  Node get tree {
    return rootNode;
  }

  List<Die> get die => rootNode.die;

  @override
  String toString() => 'Result(expr=$expr, tree=$tree)';

}

class DiceResult {

}