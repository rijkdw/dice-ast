class SetOp {

  String op, sel;
  int val;

  SetOp(this.op, this.sel, this.val);

  @override
  String toString() => 'SetOp(op=\"$op\", sel=\"$sel\", val=$val)';

}