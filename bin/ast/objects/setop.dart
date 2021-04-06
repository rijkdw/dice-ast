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

  String breakdown() {
    var opToWord = {
      'k': 'keep',
      'p': 'drop',
      'e': 'explode',
      'r': 'reroll',
      'a': 'reroll and add',
      'o': 'reroll once',
      'x': 'maximum',
      'n': 'minimum'
    };
    var selToWord = {
      '=': 'exactly',
      '>': 'larger than',
      '<': 'smaller than',
      'h': 'highest',
      'l': 'lowest'
    };
    return '${opToWord[op]} ${selToWord[sel]} $val';
  }

  // override Object methods

  @override
  String toString() => 'SetOp(op=\"$op\", sel=\"$sel\", val=$val)';

}

void main() {
  var setOps = [
    SetOp('k', 'h', 1),
    SetOp('k', 'l', 1),
    SetOp('e', 'l', 1),
    
  ];

  for (var setOp in setOps) {
    print(setOp.breakdown());
  }
}