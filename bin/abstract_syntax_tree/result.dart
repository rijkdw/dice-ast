import 'ast_node.dart';

/// A wrapper class for any [AstNode] that is the root of a tree.
/// Enables obtaining of dice total, kept and ignored dice, etc
class Result {

  AstNode rootNode;

  Result(this.rootNode);

  int get total => rootNode.value;

  AstNode get tree {
    return rootNode;
  }

  @override
  String toString() => 'Result(tree=$tree)';

}

class DiceResult {

}