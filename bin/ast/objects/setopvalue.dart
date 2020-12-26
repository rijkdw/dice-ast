class SetOpValue {

  // attributes

  int value;
  bool reusable;
  bool _used;

  SetOpValue(this.value, [bool reusable=false]) {
    this.reusable = reusable;
  }

  // "use" methods

  void use() => _used = true;

  bool get used {
    if (reusable) return false;
    return _used;
  }

  bool get available => !used;

}