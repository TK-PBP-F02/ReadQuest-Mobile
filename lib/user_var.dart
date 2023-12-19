import 'package:readquest/models/user.dart';

class SharedVariable {
  // ignore: avoid_init_to_null
  static User? _user = null;

  static User? get user => _user;

  static void setSharedValue(User? value) {
    _user = value;
  }
}