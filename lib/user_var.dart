
import 'package:readquest/models/book.dart';
import 'package:readquest/models/user.dart';

class SharedVariable {
  // ignore: avoid_init_to_null
  static User? _user = null;

  static List<Books> _books = []; 

  static User? get user => _user;

  static List<Books>? get books => _books;

  static void setSharedValue(User? value) {
    _user = value;
  }

  static void setList(List<Books> val){
    _books = val;
  }
}