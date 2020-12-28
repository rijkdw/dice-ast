class SetOp {

  // attributes

  String op, sel;
  int val;

  // constructor

  SetOp(this.op, this.sel, this.val);

  // methods

  void interpret() {}

  // getters

  bool get isValid => !(['n', 'x'].contains(op) && ['>', '<', 'h', 'l'].contains(sel));
  bool get isInvalid => !isValid;

  bool get isAbsoluteSelector => ['>', '=', '<'].contains(sel);
  bool get isRelativeSelector => !isAbsoluteSelector;

  bool get isInfiniteOperator => ['r', 'e'].contains(op);
  bool get isFiniteOperator => !isInfiniteOperator;

  // override Object methods

  @override
  String toString() => 'SetOp(op=\"$op\", sel=\"$sel\", val=$val)';

}