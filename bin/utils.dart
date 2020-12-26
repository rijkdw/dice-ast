import 'dart:io';
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

String prettify(dynamic input) {

  // cast to String
  String inputString;
  if (!(input is String)) {
    inputString = input.toString();
  } else {
    inputString = (input as String);
  }

  // remove whitespace after commas
  while (inputString.contains(', ')) {
    inputString = inputString.replaceAll(', ', ',');
  }

  var indent = 0;
  var output = '';

  void linebreak() {
    output += '\n' + '   '*indent;
  }

  for (var i = 0; i < inputString.length; i++) {
    var c = inputString[i];
    if (c == '(' || c == '[') {
      output += c;
      indent++;
      linebreak();
    } else if (c == ')' || c == ']') {
      indent--;
      linebreak();
      output += c;
    } else if (c == ',') {
      output += c;
      linebreak();
    } else {
      output += c;
    }
  }
  return output;
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

List<int> makeList(num min, num max) {
  /// Return a [List<int>] containing all int values in the range [min, max],
  /// including both values.
  if (min > max) {
    return <int>[];
  }
  if (min == max) {
    return [min];
  }
  var length = max-min+1;
  return List.generate(length, (i) => min+i);
}

List<dynamic> sublist(List<dynamic> inList, int start, int end) {
  if (inList.length-1 < end) {
    throw Exception('List with length=${inList.length} (last index=${inList.length-1}) cannot be sublisted as [$start, $end]');
  }
  var outList = <dynamic>[];
  for (var i = 0; i < inList.length; i++) {
    if (i >= start && i <= end) {
      outList.add(inList[i]);
    }
  }
  return outList;
}

List<dynamic> listSubtraction(List<dynamic> listA, List<dynamic> listB) {
  // A = [1, 1, 2, 3]
  // B = [1, 3]
  // A-B = [1, 2]
  var listC = List<int>.from(listA);
  for (var i = 0; i < listB.length; i++) {
    var b = listB[i];
    listC.remove(b);
  }
  return listC;
}

void main() {
  var myStrings = ['a', 'b', 'c'];
  print(join(myStrings, ','));
  print(join(myStrings, '-'));
  print(wrapWith('hey', "'"));
  print(wrapWith('hey', '(', ')'));
  print(makeList(3, 6));
  print(makeList(6, 6));
  print(listSubtraction([1, 1, 2, 3, 4, 4, 5], [1, 3, 4, 5, 6]));
  prettify('a b, c');
}