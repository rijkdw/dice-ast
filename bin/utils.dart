import 'dart:math';

// BOOLEANS

bool isNumeric(String s) {
  if (s == null) return false;
  if (s.length > 1) return false;
  return double.parse(s, (e) => null) != null;
}

bool isDigit(String s) => isNumeric(s) && s.length == 1;

bool isSpace(String s) => s.trim().isEmpty;

// RANDOM

Random _random = Random();

// [min, max]
int randInRange(int min, int max) => min + _random.nextInt(max + 1 - min);

// STRINGS

String join(List<dynamic> list, String delim) {
  var output = '';
  for (var i = 0; i < list.length-1; i++) {
    output += list[i].toString();
    output += delim;
  }
  output += list.last;
  return output;
}

String wrapWith(String s, String w, [String r]) {
  return w + s + (r ?? w);
}

// LISTS

int countInList(List<dynamic> list, dynamic val, [Function map]) {
  if (map != null) {
    list = list.map(map).toList();
  }
  var count = 0;
  list.forEach((item) {
    if (item == val) {
      count++;
    }
  });
  return count;
}

num sumList(List<num> list) {
  num sum = 0;
  list.forEach((v) => sum += v);
  return sum;
}

void main() {
  var myStrings = ['a', 'b', 'c'];
  print(join(myStrings, ','));
  print(join(myStrings, '-'));
  print(wrapWith('hey', "'"));
  print(wrapWith('hey', '(', ')'));
}