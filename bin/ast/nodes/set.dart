import '../objects/token.dart';
import 'node.dart';
import 'setlike.dart';

class Set extends SetLike {

  // attributes

  Token token;

  // constructor

  Set(this.token, List<Node> children) {
    this.children = children;
  }

  // override Object methods

  @override
  String toString() => 'Set(children=$children, setOps=$setOps)';

}