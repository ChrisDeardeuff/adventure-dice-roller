import 'package:nyxx/nyxx.dart' as nyxx;

import '../models/user.dart';

class UserServices {
  static final UserServices _singleton = UserServices._internal();

  factory UserServices() {
    return _singleton;
  }

  UserServices._internal();

  var users = <nyxx.Snowflake, User>{};

  User registerUser(nyxx.Snowflake id) {
    //if user is not already in the map of users add and return user
    if (!users.containsKey(id)) {
      users[id] = User(id);
      return users[id]!;
    } else {
      return users[id]!;
    }
  }
}
