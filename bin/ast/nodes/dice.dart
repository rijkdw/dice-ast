import '../../utils.dart';
import 'die.dart';
import '../objects/token.dart';
import 'setlike.dart';

class Dice extends SetLike {

  // attributes

  Token token;
  int number, size;
  // children (from SetLike) will all be Die nodes.

  // constructor

  Dice(this.token, this.number, this.size);

  // factory

  factory Dice.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return Dice(token, int.parse(matches.first), int.parse(matches.last));
  }

  // methods

  /// Roll [number]d[size].
  void roll() {
    children = <Die>[];
    for (var i = 0; i < number; i++) {
      children.add(_rollAnother());
    }
  }

  /// Roll one [Die] according to this [Dice]'s [size].
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