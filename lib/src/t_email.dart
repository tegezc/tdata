class TEmail {
  final String _stringEmail;
  final bool _isValid;

  TEmail._(this._stringEmail, this._isValid);

  factory TEmail.fromString(String email) {
    if (email.isEmpty || email.length >= 255) {
      return TEmail._(email, false);
    }

    try {
      Pattern stringEmail =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      bool emailValid = RegExp(stringEmail as String).hasMatch(email);

      return TEmail._(email, emailValid);
    } catch (e) {
      return TEmail._(email, false);
    }
  }

  String get stringEmail => _stringEmail;
  bool get isValid => _isValid;
}
