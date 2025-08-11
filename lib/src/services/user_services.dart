import 'dart:convert';
import 'dart:io';
import 'package:supabase/supabase.dart';
import 'package:nyxx/nyxx.dart' as nyxx;

import '../models/user.dart';

class UserServices {

  static const supabaseUrl = 'https://paxcmehxsyyhzspxbdtm.supabase.co';
  static final supabaseKey = Platform.environment['SUPABASE_KEY'];

  final nyxx.Logger _logger = nyxx.Logger('ADR.user_service');

  static final UserServices _singleton = UserServices._internal();
  final supabase = SupabaseClient(
    supabaseUrl,
    supabaseKey!,
  );

  factory UserServices() {
    return _singleton;
  }

  UserServices._internal();

  var users = <nyxx.Snowflake, ADRUser>{};

  supaInit() async {
    try {

      _logger.info('Connecting to database');

      supabase.from('user_preferences').select();

    } catch (e) {
      _logger.severe('Database connection Failed $e');
      return;
    }

    _logger.info('Connected to database');
  }

  userSetSystem(ADRUser user) async {
    try {
      // var collection = db.collection('user_preferences');
      //
      // collection.update(where.eq('id', user.id.toString()),
      //     modify.set('selectedSystem', user.selectedSystem.name));

      await supabase.from('user_preferences').update({'selectedSystem': user.selectedSystem.name}).eq('id', user.id.toString());
      _logger.info('System updated for: ${user.id.toString()}');
    } catch (e) {
      _logger.severe('Error updating system: $e');
    }
  }

  Future<ADRUser> registerUser(nyxx.Snowflake id) async {

    final getUser =  await supabase.from('user_preferences').select('id, selectedSystem, quickRolls').eq('id', id);

    if(getUser.isEmpty){
      _logger.info("Creating new user");
      var newUser = await newUserSetup(id);
      return newUser;
    }else{
      _logger.info("Found User: ${getUser.first}");
      return ADRUser.fromJson(getUser.first);
    }
  }

  Future<ADRUser> newUserSetup(nyxx.Snowflake id) async {
    // //create a new preferences document
    ADRUser newUser = ADRUser(id);

    //try to put user in db
    try {
      var userJson = newUser.toJson();
      await supabase.from('user_preferences').insert({'id': id.toString(), 'selectedSystem': newUser.selectedSystem.toString(), 'quickRolls': userJson['quickRolls'] });
    } catch (e) {
      _logger.severe("error creating user: $e");
    }

    return newUser;
  }

  ///Set Quick Roll will set the Quick Roll number (index) to the provided roll for the provided user and their current system
  ///index = quick roll number in the system (1-10)
  ///roll = valid roll for the selected system
  ///user = current user of the bot
  setQuickRoll(int index, String roll, ADRUser user) async {
    try {
      _logger.info("setting quick roll");
      _logger.info(jsonEncode(user));
      //update the QR in the user object
      var qrIndex = user.quickRolls.indexWhere(
          (element) => element.selectedSystem == user.selectedSystem);
      user.quickRolls[qrIndex].setQuickRoll(index, roll);

      await supabase.from('user_preferences').update({'quickRolls': jsonEncode(user.quickRolls)}).eq('id', user.id.toString());

      _logger.info('quick roll $index updated for: ${user.id.toString()}');
    } catch (e) {
      _logger.severe('Error updating quick rolls: $e');
    }
  }
}
