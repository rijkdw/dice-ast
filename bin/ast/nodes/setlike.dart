import '../objects/setop.dart';
import 'node.dart';
import 'set.dart';

class SetLike extends Node {

  // attributes

  List<Node> children = <Node>[];
  List<SetOp> setOps = <SetOp>[];

  // override Node methods

  @override
  int get value {
    var sum = 0;
    children.forEach((child) => sum += child.isKept ? child.value : 0);
    return sum;
  }

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

  void applySetOps() {
    for (var i = 0; i < setOps.length; i++) {
      var setOp = setOps[i];

      // check if setOp can be applied to this SetLike
      if (['e', 'r', 'o', 'a'].contains(setOp.op) && this is Set) continue;
      
      // if an infinite op ('e' or 'r')
      if (setOp.isInfiniteOperator) {
        // merge them together
      }
    }
  }
}