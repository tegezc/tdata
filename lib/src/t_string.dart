class TString {
  final String _realValue;
  TString._(this._realValue);

  factory TString.string(String str) {
    return TString._(str);
  }

  String get realValue => _realValue;
}
