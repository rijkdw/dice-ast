import '../../utils.dart';
import 'die.dart';
import '../objects/token.dart';
import 'setlike.dart';

class Dice extends SetLike {

  // attributes

  Token token;
  int number, size;

  // constructor

  Dice(this.token, this.number, this.size);

  // factory

  factory Dice.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return Dice(token, int.parse(matches.first), int.parse(matches.last));
  }

  // methods

  void evaluate() {
    // operators:
    // k, p:      mark Die as unkept, as appropriate by selector
    // e:         mark Die as exploded and roll another die
    // r, o, a:   reroll Die...
      // r        reroll Die infinitely, discard original
      // o        reroll Die once, discard original
      // a        reroll Die once, keep original
    // n, x:      overwrite Die value with V if smaller / larger than V

    // selectors:
    // h, l:      require access to full values
    // s, >, <    do not require access to full values

    // invalid selectors for operators:
    // n, x:      >, <, h, l
  }

  Die _rollAnother() {
    return Die.roll(size);
  }

  // override Node methods

  @override
  List<Die> get die => List<Die>.from(children);

  @override
  String visualise() {
    var setOpsVisualised = join(setOps.map((s) => '${s.op}${s.sel}${s.val}').toList(), '');
    return '${number}d${size}${setOpsVisualised}';
  }

  // override Object methods

  @override
  String toString() {
    var output = 'Dice(number=$number, size=$size, children=$children, setOps=$setOps)';
    return output;
  }

  
}