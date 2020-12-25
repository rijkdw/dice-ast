import 'ast_node.dart';
import 'die.dart';

class SetOp {

  String op, sel;
  int val;

  SetOp(this.op, this.sel, this.val);

  @override
  String toString() => 'SetOp(op=\"$op\", sel=\"$sel\", val=$val)';

  bool get isValid => !(['n', 'x'].contains(op) && ['>', '<', 'h', 'l'].contains(sel));

  void applyKeepDropToDie(Die die) {
    var selToConditional = {
      '>': (Die die) => die.value > val,
      '<': (Die die) => die.value < val,
      '=': (Die die) => die.value == val,
    };
    // if keeping, discard those which don't meet condition
    if (op == 'k' && !selToConditional[sel](die)) {
      die.discard();
    }
    // if dropping, discard those which meet condition
    if (op == 'p' && selToConditional[sel](die)) {
      die.discard();
    }
  }

  void applyKeepDropToLiteral(LiteralNode literal) {
    var selToConditional = {
      '>': () => literal.value > val,
      '<': (LiteralNode literal) => literal.value < val,
      '=': (LiteralNode literal) => literal.value == val,
    };
    // if keeping, discard those which don't meet condition
    if (op == 'k' && !selToConditional[sel](literal)) {
      literal.discard();
    }
    // if dropping, discard those which meet condition
    if (op == 'p' && selToConditional[sel](literal)) {
      literal.discard();
    }
  }

  // static methods

  static List<SetOp> groupByOp(List<SetOp> inList) {
    var outList = <SetOp>[];
    var opsGrouped = <String>[];
    for (var setOp in inList) {
      if (!opsGrouped.contains(setOp.op)) {
        opsGrouped.add(setOp.op);
        outList.add(setOp);
        for (var setOp2 in inList) {
          if (setOp.op == setOp2.op && setOp != setOp2) {
            outList.add(setOp2);
          }
        }
      }
    }
    return outList;
  }

  static List<SetOp> filterByOp(List<SetOp> inList, String targetOp) {
    var outList = <SetOp>[];
    for (var setOp in inList) {
      if (setOp.op == targetOp) {
        outList.add(setOp);
      }
    }
    return outList;
  }
}

void main() {
  var inList = [
    SetOp('rr', '=', 1),
    SetOp('e', '=', 2),
    SetOp('rr', '=', 3),
    SetOp('e', '=', 4),
  ];
  var outList = SetOp.groupByOp(inList);
  print(outList);

  var setOp = SetOp('n', 's', 3);
  print(setOp.isValid);
}