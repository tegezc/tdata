const tDataIntDefaultValue = 0;

class TInt {
  final int _realValue;
  final bool _isSuccess;

  TInt._int(this._realValue, this._isSuccess);

  factory TInt._string(String strInt, {int? valueIfError}) {
    int? realValue = int.tryParse(strInt.trim());
    bool successParse = true;
    int defValue = tDataIntDefaultValue;

    if (valueIfError != null) {
      defValue = valueIfError;
    }

    if (realValue == null) {
      successParse = false;
      realValue = defValue;
    }

    return TInt._int(realValue, successParse);
  }

  factory TInt.fromInt(int value) {
    return TInt._int(value, true);
  }

  factory TInt.fromString(String strInt, {int? valueIfError}) {
    return TInt._string(strInt, valueIfError: valueIfError);
  }

  int get realValue => _realValue;
  bool get isSuccess => _isSuccess;
}
