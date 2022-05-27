const tDataDoubleDefaultValue = 0.0;

class TDouble {
  final double _realValue;
  final bool _isSuccess;

  TDouble._(this._realValue, this._isSuccess);

  factory TDouble._string(String strInt, {double? valueIfError}) {
    double? rValue = double.tryParse(strInt.trim());
    bool successParse = true;
    double defValue = tDataDoubleDefaultValue;

    if (valueIfError != null) {
      defValue = valueIfError;
    }

    if (rValue == null) {
      successParse = false;
      rValue = defValue;
    }

    return TDouble._(rValue, successParse);
  }

  factory TDouble.fromDouble(double valueDouble) {
    return TDouble._(valueDouble, true);
  }

  factory TDouble.fromString(String valueDouble, {double? valueIfError}) {
    return TDouble._string(valueDouble, valueIfError: valueIfError);
  }

  double get realValue => _realValue;
  bool get isSuccess => _isSuccess;
}
