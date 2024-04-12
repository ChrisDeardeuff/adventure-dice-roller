import 'package:nyxx/nyxx.dart';

import 'systems.dart';

class User {
  System selectedSystem = System.none;
  Snowflake id;

  User(this.id);
}
