import 'dart:ffi';

import 'package:nyxx/nyxx.dart';

import 'systems.dart';

class User {
  System selectedSystem = System.none;
  Snowflake id;
  List<List<String>>? quickRolls;

  User(this.id);

  User.fromJson(Map<String, dynamic> json)
      : id = Snowflake.parse(int.parse((json['_id']).toString())),
        selectedSystem = System.values.byName(json['system']),
        quickRolls = json['quickRolls'] == ''
            ? null
            : json['quickRolls'] as List<List<String>>;

  Map<String, dynamic> toJson() => {
        '_id': id.value,
        'system': selectedSystem.name.toString(),
        'quickRolls': quickRolls != null ? quickRolls.toString() : ''
      };
}
