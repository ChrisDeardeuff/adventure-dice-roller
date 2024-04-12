import 'package:nyxx/nyxx.dart';

import 'systems.dart';

class User{

   System _selectedSystem = System.none;
   Snowflake _id;

   User(this._id);

   Snowflake get id => _id;

  set id(Snowflake value) {
    _id = value;
  }

  System get selectedSystem => _selectedSystem;

  set selectedSystem(System value) {
    _selectedSystem = value;
  }
}