import '../../utils.dart';
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
  
  // override Node methods

  @override
  String visualise() => '(' + join(children.map((c) => c.visualise()).toList(), ', ') + ')';

  // @override
  // List<Die> get die => List<Die>.from(joinLists(children.map((child) => child.die).toList()));

  // override Object methods

  @override
  String toString() => 'Set(children=$children, setOps=$setOps)';

}