import '../objects/setop.dart';
import 'node.dart';

class SetLike extends Node {

  List<SetOp> setOps;

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }
}