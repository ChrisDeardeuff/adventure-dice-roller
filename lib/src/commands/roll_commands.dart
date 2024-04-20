import 'dart:math';

import 'package:adventure_dice_roller/server.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import '../services/user_services.dart';
import '../models/systems.dart';

final Logger _logger = Logger('ADR.Rolls');
UserServices us = UserServices();
final hiddenMessage = ResponseLevel(
    hideInteraction: true,
    isDm: false,
    mention: true,
    preserveComponentMessages: true);
var rng = Random();

final roll = ChatCommand(
  'roll',
  "Default roll for selected system! Visit the documentation or use /roll-help to see valid rolls",
  id(
    'roll',
    (ChatContext context, [String? roll]) async {
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;

      //check if valid inputs
      if (roll == null || isValidRoll(system, roll)) {
        await context.respond(
            MessageBuilder(
                content:
                    'Invalid input for the current selected system: ${system.name}. '
                    'Please refer to /help or the online documentation for the proper formatting'),
            level: hiddenMessage);
        return;
      }

      switch (system) {
        case System.none:
          await context.respond(MessageBuilder(content: rollNone(roll)));
          return;

        case System.asoif:
          await context.respond(MessageBuilder(content: rollASOIF(roll)));
          return;

        case System.age:
          await context.respond(MessageBuilder(content: rollAGE(roll)));
          return;

        case System.dnd:
          await context.respond(
              MessageBuilder(content: "System is not implemented yet, sorry!"));
        // TODO: Handle this case.
      }
    },
  ),
);

final setQr = ChatCommand(
  'set-qr',
  "Sets a quick roll, an easily executable roll for whatever system is selected",
  id(
    'set-qr',
    (ChatContext context, [String? num, String? roll]) async {
      if (num == null || roll == null) {
        await context.respond(MessageBuilder(
            content:
                'Error setting quick roll, please make sure all values are set. Refer to /help if you need help'));
        return;
      }
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;
      var numOfQR = int.parse(num);

      if (!(numOfQR <= 10 && numOfQR >= 1)) {
        await context.respond(MessageBuilder(
            content:
                'Error setting quick roll, please make sure your number is between 1-10'));
        return;
      }
      //check if a roll was provided, it is a valid roll for the system, and the number is 1-10
      if (isValidRoll(system, roll)) {
        try {
          await us.setQuickRoll(numOfQR, roll, user);
        } catch (e) {
          _logger.severe("error setting quick roll.. $e");
          await context.respond(MessageBuilder(
              content:
                  'Error setting quick roll, please try again in a few minutes. '
                  'If the error persists please contact dev'));
          return;
        }
      } else {
        _logger.severe("Invalid Roll or Roll is Null");
        await context.respond(MessageBuilder(
            content:
                'roll = $roll - is an invalid roll for system: ${system.name} '
                'or roll parameter is empty, please try again or use /help for help'));
        return;
      }

      await context
          .respond(MessageBuilder(content: 'quick roll $num, set to $roll'));
    },
  ),
);

final qr = ChatCommand(
  'qr',
  "rolls a quick roll, an easily executable roll for whatever system is selected",
  id(
    'qr',
    (ChatContext context, [String? num]) async {
      if (num == null) {
        await context.respond(MessageBuilder(
            content:
                'Error rolling quick roll, please make sure all values are set. Refer to /help if you need help'));
        return;
      }
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;
      var numOfQR = int.parse(num);

      if (!(numOfQR <= 10 && numOfQR >= 1)) {
        await context.respond(MessageBuilder(
            content:
                'Error rolling quick roll, please make sure your number is between 1-10'));
        return;
      }
      var qrIndex = user.quickRolls
          .indexWhere((element) => element.selectedSystem == system);

      String roll = user.quickRolls[qrIndex].getQuickRoll(numOfQR);
      _logger.info('roll is $roll');
      switch (system) {
        case System.none:
          await context.respond(MessageBuilder(content: rollNone(roll)));
          return;

        case System.asoif:
          await context.respond(MessageBuilder(content: rollASOIF(roll)));
          return;

        case System.age:
          await context.respond(MessageBuilder(content: rollAGE(roll)));
          return;

        case System.dnd:
          await context.respond(
              MessageBuilder(content: "System is not implemented yet, sorry!"));
        // TODO: Handle this case.
      }
    },
  ),
);

bool isValidRoll(System system, String roll) {
  var rollPattern = RegExp(r'\b[0-9]{1,6}d[0-9]{1,6}');

  switch (system) {
    case System.none:
      if (rollPattern.hasMatch(roll)) {
        return true;
      }
      return false;
    case System.asoif:
      rollPattern = RegExp(r'\b[0-9]{1,6}b[0-9]{1,6}');
      if (rollPattern.hasMatch(roll)) {
        return true;
      }
      return false;
    case System.age:
      rollPattern = RegExp(r'^\d$');
      if (rollPattern.hasMatch(roll)) {
        return true;
      }
      return false;
    case System.dnd:
      // TODO: Handle this case.
      return true;
  }
}

String rollASOIF(String roll) {
  List<int> rolls = [];
  var sum = 0;

  int numberOfDice = int.parse(roll.substring(0, roll.indexOf("b")));
  int numberOfBonusDice = int.parse(roll.substring(roll.indexOf("b") + 1));

  //roll base dice and bonus dice
  rolls = rollHelper(
      numberOfDice: numberOfDice + numberOfBonusDice, numberOfSides: 6);
  //sort in descending order
  rolls.sort((b, a) => a.compareTo(b));
  //take only the top x rolls
  var finalRolls = rolls.take(numberOfDice).toList();
  //sum the top x rolls
  sum = finalRolls.reduce((value, element) => value + element);

  return 'Rolled: ${rolls.toString()}. The highest $numberOfDice is: $finalRolls = $sum';
}

String rollAGE(String roll) {
  List<int> rolls = [];
  var sum = 0;

  int attMod = int.parse(roll);
  //roll base dice
  rolls = rollHelper(numberOfDice: 3, numberOfSides: 6);
  //sum the rolls and add mod
  sum = rolls.reduce((value, element) => value + element) + attMod;

  // Convert the list to a Set (Sets only store unique values)
  Set<int> uniqueNumbers = rolls.toSet();
  // Check if the original list and set have different lengths
  bool hasDuplicates = uniqueNumbers.length != rolls.length;
  if (hasDuplicates) {
    return 'Rolled: ${rolls.toString()} + $attMod = $sum and generated ${rolls.last} stunt points!';
  } else {
    return 'Rolled: ${rolls.toString()} + $attMod = $sum';
  }
}

String rollNone(String roll) {
  List<int> rolls = [];
  var sum = 0;

  int numberOfDice = int.parse(roll.substring(0, roll.indexOf("d")));
  int sidesOfDice = int.parse(roll.substring(roll.indexOf("d") + 1));
  rolls = rollHelper(numberOfDice: numberOfDice, numberOfSides: sidesOfDice);
  sum = rolls.reduce((value, element) => value + element);

  return '$rolls = $sum';
}

List<int> rollHelper({required int numberOfDice, required int numberOfSides}) {
  List<int> roll = [];

  for (int i = 0; i < numberOfDice; i++) {
    roll.add((rng.nextInt(numberOfSides - 1) + 1));
  }

  return roll;
}
