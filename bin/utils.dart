import 'dart:math';

// boolean checks

bool isNumeric(String s) {
  if (s == null) return false;
  if (s.length > 1) return false;
  return double.parse(s, (e) => null) != null;
}

bool isDigit(String s) => isNumeric(s) && s.length == 1;

bool isSpace(String s) => s.trim().isEmpty;

// random

Random _random = Random();

// [min, max]
int randInRange(int min, int max) => min + _random.nextInt(max + 1 - min);

void main() {
  var map = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
  for (var i = 0; i < 10000000; i++) {
    var value = randInRange(1, 6);
    map[value]++;
  }
  print(map);
}
