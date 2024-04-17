import 'dart:io';

import 'package:adventure_dice_roller/server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart' as nyxx;

import '../models/user.dart';

class UserServices {
  final nyxx.Logger _logger = nyxx.Logger('ADR.Database');

  static final UserServices _singleton = UserServices._internal();

  factory UserServices() {
    return _singleton;
  }

  UserServices._internal();

  late Db db;

  var users = <nyxx.Snowflake, User>{};

  mongoInit() async {
    try {
      _logger.info('Connecting to database');
      db = await Db.create(
          'mongodb://${Platform.environment['DB_USER']}:${Platform.environment['DB_PASS']}@${Platform.environment['DB_IP']}:27017/user_preferences');
      await db.open();
    } catch (e) {
      _logger.severe('Database connection Failed $e');
      return;
    }

    _logger.info('Connected to database');
  }

  userSetSystem(User user) {
    try {
      var collection = db.collection('user_preferences');

      collection.update(where.eq('_id', user.id.value),
          modify.set('system', user.selectedSystem.name));
      _logger.info('System updated for: ${user.id.value}');
    } catch (e) {
      _logger.severe('Error updating system: $e');
    }
  }

  Future<User> registerUser(nyxx.Snowflake id) async {
    var collection = db.collection('user_preferences');
    _logger.info(id.value.toString());

    var userSearch = await collection.findOne(where.eq('_id', id.value));
    _logger.info(userSearch);
    // Check if the result is null
    if (userSearch == null) {
      _logger.info("Creating new user");
      //create a new preferences document
      User newUser = User(id);
      //try to put user in db
      try {
        WriteResult wr = await collection.insertOne(newUser.toJson());
      } catch (e) {
        _logger.info("error creating user: $e");
      }

      return newUser;
    } else {
      _logger.info("got user: $userSearch");
      return User.fromJson(userSearch);
    }
  }
}
