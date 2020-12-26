class SetOp {

  String op, sel;
  int val;

  SetOp(this.op, this.sel, this.val);

  @override
  String toString() => 'SetOp(op=\"$op\", sel=\"$sel\", val=$val)';

  bool get isValid => !(['n', 'x'].contains(op) && ['>', '<', 'h', 'l'].contains(sel));

}