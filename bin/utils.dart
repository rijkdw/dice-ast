bool isNumeric(String s) {
  if (s == null) return false;
  if (s.length > 1) return false;
  return double.parse(s, (e) => null) != null;
}

bool isDigit(String s) => isNumeric(s) && s.length == 1;

bool isSpace(String s) {
  return s.trim().isEmpty;
}
