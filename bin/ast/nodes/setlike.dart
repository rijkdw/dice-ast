import '../objects/setop.dart';
import 'node.dart';

class SetLike extends Node {

  // attributes

  List<Node> children = <Node>[];
  List<SetOp> setOps = <SetOp>[];

  // override Node methods

  @override
  int get value {
    var sum = 0;
    children.forEach((child) => sum += child.kept ? child.value : 0);
    return sum;
  }

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }
}