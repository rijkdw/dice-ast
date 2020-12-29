import 'package:collection/collection.dart';
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

bool listEquality(List<dynamic> listA, List<dynamic> listB) {
  var eq = ListEquality().equals;
  return eq(listA, listB);
}

List<dynamic> joinLists(List<List<dynamic>> listOfLists) {
  var returnList = [];
  for (var list in listOfLists) {
    returnList.addAll(list);
  }
  return returnList;
}

int maxInList(List<int> list, [Function map]) {
  if (map != null) {
    list = list.map(map).toList();
  }
  return list.reduce(max);
}

int minInList(List<int> list, [Function map]) {
  if (map != null) {
    list = list.map(map).toList();
  }
  return list.reduce(min);
}

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

int sumList(List<int> list) {
  var sum = 0;
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
  var countRollovers = 0;
  while (end < 0 && countRollovers < 100) {
    end += inList.length-1;
    countRollovers++;
  }
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

List<int> getSafeMaxN(List<int> inList, int n) {
  var big2small = List<int>.from(inList);
  big2small.sort();
  big2small = big2small.reversed.toList();  
  return getSafeFirstN(big2small, n);
}

List<int> getSafeMinN(List<int> inList, int n) {
  var small2big = List<int>.from(inList);
  small2big.sort();
  return getSafeFirstN(small2big, n);
}

List<int> getSafeFirstN(List<int> inList, int n) {
  if (n > inList.length) {
    return inList;
  }
  return List<int>.from(sublist(inList, 0, n-1));
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
  print(getSafeMaxN([1, 3, 4, 2], 2));
  print(getSafeMinN([1, 3, 4, 2], 5));
  print(joinLists([[1, 2, 3], [4, 5]]));
  print(sublist([1, 2, 3], 0, -1));
}