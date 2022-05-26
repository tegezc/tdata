class TBool {
  final bool _realValue;
  final bool _isSuccess;
  TBool._(this._realValue, this._isSuccess);

  factory TBool.fromBool(bool boolValue) {
    return TBool._(boolValue, true);
  }
  factory TBool.fromInt(int boolValue) {
    if (boolValue == 1) return TBool._(true, true);
    if (boolValue == 0) return TBool._(false, true);

    return TBool._(false, false);
  }

  factory TBool.fromString(String boolValue) {
    if (boolValue.trim() == '1') return TBool._(true, true);
    if (boolValue.trim() == '0') return TBool._(false, true);
    return TBool._(false, false);
  }

  bool get realValue => _realValue;
  bool get isSuccess => _isSuccess;
}
