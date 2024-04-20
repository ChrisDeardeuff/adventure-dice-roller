import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart' as nyxx;

import '../models/user.dart';

class UserServices {
  final nyxx.Logger _logger = nyxx.Logger('ADR.user_service');

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

      collection.update(where.eq('id', user.id.toString()),
          modify.set('selectedSystem', user.selectedSystem.name));
      _logger.info('System updated for: ${user.id.toString()}');
    } catch (e) {
      _logger.severe('Error updating system: $e');
    }
  }

  Future<User> registerUser(nyxx.Snowflake id) async {
    var collection = db.collection('user_preferences');
    _logger.info(id.value.toString());

    var userSearch =
        await collection.findOne(where.eq('id', id.value.toString()));
    _logger.info(userSearch);
    // Check if the result is null
    if (userSearch == null) {
      _logger.info("Creating new user");
      var newUser = await newUserSetup(id);

      return newUser;
    } else {
      _logger.info("got user: $userSearch");
      return User.fromJson(userSearch);
    }
  }

  Future<User> newUserSetup(nyxx.Snowflake id) async {
    //create a new preferences document
    User newUser = User(id);

    //try to put user in db
    try {
      var userCollection = db.collection('user_preferences');

      await userCollection.insertOne(newUser.toJson());
    } catch (e) {
      _logger.severe("error creating user: $e");
    }

    return newUser;
  }

  ///Set Quick Roll will set the Quick Roll number (index) to the provided roll for the provided user and their current system
  ///index = quick roll number in the system (1-10)
  ///roll = valid roll for the selected system
  ///user = current user of the bot
  setQuickRoll(int index, String roll, User user) async {
    try {
      _logger.info("setting quick roll");
      _logger.info(jsonEncode(user));
      //update the QR in the user object
      var qrIndex = user.quickRolls.indexWhere(
          (element) => element.selectedSystem == user.selectedSystem);
      user.quickRolls[qrIndex].setQuickRoll(index, roll);
      //get the collection of documents
      var collection = db.collection('user_preferences');
      //get the document corresponding to current user and update the quickRolls
      collection.update(where.eq('id', user.id.toString()),
          modify.set('quickRolls', jsonEncode(user.quickRolls)));
      _logger.info('quick roll $index updated for: ${user.id.toString()}');
    } catch (e) {
      _logger.severe('Error updating quick rolls: $e');
    }
  }
}
