import 'abstract_syntax_tree/roller.dart';

class MyApp {

  String diceExpression;

  MyApp(this.diceExpression);

  void display() {
    var result = Roller.roll(diceExpression);
    print(result.total);
    var die = result.die;
    for (var d in die) {
      print(d);
    }
  }

}

void main() {
  var input = '4d6kh3n=3';
  var app = MyApp(input);
  app.display();
}