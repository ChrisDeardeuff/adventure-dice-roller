import 'dart:math';

import 'package:adventure_dice_roller/server.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import '../services/user_services.dart';
import '../models/systems.dart';

/// Logger for roll-related events and errors.
final Logger _logger = Logger('ADR.Rolls');

/// Provides user data and operations.
UserServices us = UserServices();

/// Configuration for hiding bot responses from the main chat, sending them as direct messages to the user instead.
final hiddenMessage = ResponseLevel(
    hideInteraction: true,
    isDm: false,
    mention: true,
    preserveComponentMessages: true);

/// Random number generator for dice rolls.
var rng = Random();

/// Chat command to perform a default roll based on the user's selected system.
final roll = ChatCommand(
  'roll',
  "Default roll for selected system! Visit the documentation or use /roll-help to see valid rolls",
  id(
    'roll',
    (ChatContext context,
        [@Description(
            "Required option used to define a roll. Refer to /roll-help for more info")
        String? roll,
        @Description(
            "Optional options used in some systems like 5e. Refer to /roll-help")
        String options = '']) async {
      /// 1. Get user data (or create if new) and fetch their selected system.
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;

      /// 2. Validate if the roll input is correct for the chosen system.
      if (roll == null || !isValidRoll(system, roll)) {
        await context.respond(
            MessageBuilder(
                content:
                    'Invalid input for the current selected system: ${system.name}. '
                    'Please refer to /help or the online documentation for the proper formatting'),
            level: hiddenMessage);
        return;
      }

      /// 3. Execute the roll function based on the system, sending the result back to the user.
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
          await context
              .respond(MessageBuilder(content: rollDnd(roll, options)));
          return;
      }
    },
  ),
);

/// Chat command to set a quick roll for a specific system.
final setQr = ChatCommand(
  'set-qr',
  "Sets a quick roll, an easily executable roll for whatever system is selected",
  id(
    'set-qr',
    (ChatContext context,
        [@Description(
            "Required option used to index a quick roll between 1-10. Refer to /help for more info")
        String? num,
        @Description(
            "Required option used to define a roll. Refer to /roll-help for more info")
        String? roll]) async {
      if (num == null || roll == null) {
        await context.respond(
            MessageBuilder(
                content:
                    'Error setting quick roll, please make sure all values are set. Refer to /help if you need help'),
            level: hiddenMessage);
        return;
      }
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;
      var numOfQR = int.parse(num);

      if (!(numOfQR <= 10 && numOfQR >= 1)) {
        await context.respond(
            MessageBuilder(
                content:
                    'Error setting quick roll, please make sure your number is between 1-10'),
            level: hiddenMessage);
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
        await context.respond(
            MessageBuilder(
                content:
                    'roll = $roll - is an invalid roll for system: ${system.name} '
                    'or roll parameter is empty, please try again or use /help for help'),
            level: hiddenMessage);
        return;
      }

      await context.respond(
          MessageBuilder(content: 'quick roll $num, set to $roll'),
          level: hiddenMessage);
    },
  ),
);

/// Chat command to execute a previously set quick roll.
final qr = ChatCommand(
  'qr',
  "rolls a quick roll, an easily executable roll for whatever system is selected",
  id(
    'qr',
    (ChatContext context, [String? num]) async {
      if (num == null) {
        await context.respond(
            MessageBuilder(
                content:
                    'Error rolling quick roll, please make sure all values are set. Refer to /help if you need help'),
            level: hiddenMessage);
        return;
      }
      var user = await us.registerUser(context.user.id);
      var system = user.selectedSystem;
      var numOfQR = int.parse(num);

      if (!(numOfQR <= 10 && numOfQR >= 1)) {
        await context.respond(
            MessageBuilder(
                content:
                    'Error rolling quick roll, please make sure your number is between 1-10'),
            level: hiddenMessage);
        return;
      }
      var qrIndex = user.quickRolls
          .indexWhere((element) => element.selectedSystem == system);

      String roll = user.quickRolls[qrIndex].getQuickRoll(numOfQR);
      _logger.info('roll is $roll');
      if (roll == 'empty') {
        await context.respond(
            MessageBuilder(
                content:
                    'Error rolling quick roll, please make sure the QR is set, see /help for help'),
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
          await context.respond(MessageBuilder(content: rollDnd(roll, '')));
          return;
      }
    },
  ),
);

/// Checks if the given `roll` string is valid for the specified `system`.
///
/// Returns `true` if the roll format matches the system's requirements, otherwise `false`.
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
      rollPattern = RegExp(r'^(\d*)d(\d+)([+\-*/](\d+))*?$');
      if (rollPattern.hasMatch(roll)) {
        return true;
      }
      return false;
  }
}

/// Rolls dice for the A Song of Ice and Fire (ASOIF) system.
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

/// Rolls dice for the AGE system.
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

String rollDnd(String roll, String options) {
  final regex = RegExp(r'^(\d*)d(\d+)([+\-*/](\d+))*$');
  final match = regex.firstMatch(roll);

  if (match == null) return "";

  final diceCount = int.tryParse(match.group(1) ?? '1') ?? 1;
  final diceType = int.parse(match.group(2)!);
  final modifiersMatch = match.group(3);

  // Roll dice twice if advantage or disadvantage is specified
  final roll1 = rollHelper(numberOfDice: diceCount, numberOfSides: diceType);
  final roll2 = options != ''
      ? rollHelper(numberOfDice: diceCount, numberOfSides: diceType)
      : null;

  final modifiers = _parseModifiers(modifiersMatch);

  final result1 = _applyModifiers(roll1, modifiers);
  final result2 = roll2 != null ? _applyModifiers(roll2, modifiers) : null;

  final hasNat20Roll1 = roll1.contains(1); // Check for a 20 in the first roll
  final hasNat1Roll1 = roll1.contains(1);// Check for a 1 in the first roll

  if (options.isEmpty) {
    return _formatResult(roll, roll1, modifiers, result1, hasNat20Roll1, hasNat1Roll1);
  }

  // If there are options, determine best/worst roll
  final bestResult = options.toUpperCase() == 'A'
      ? max(result1, result2!)
      : min(result1, result2!);
  final bestRolls = options.toUpperCase() == 'A'
      ? (result1 > result2 ? roll1 : roll2!)
      : (result1 < result2 ? roll1 : roll2!);

  final hasNat20AdvOrDis = bestRolls.contains(20);
  final hasNat1AdvOrDis = bestRolls.contains(1);

  return _formatResult(roll, roll1, modifiers, bestResult, hasNat20AdvOrDis, hasNat1AdvOrDis,
      options.toUpperCase(), roll2);
}

//DND HELPERS
List<(String, int)> _parseModifiers(String? modifiersMatch) {
  final modifiers = <(String, int)>[];
  if (modifiersMatch != null) {
    final modifierRegex = RegExp(r'([+\-*/])(\d+)');
    for (final match in modifierRegex.allMatches(modifiersMatch)) {
      modifiers.add((match.group(1)!, int.parse(match.group(2)!)));
    }
  }
  return modifiers;
}

int _applyModifiers(List<int> rolls, List<(String, int)> modifiers) {
  var sum = rolls.reduce((value, element) => value + element);
  for (final (operator, value) in modifiers) {
    switch (operator) {
      case '+':
        sum += value;
        break;
      case '-':
        sum -= value;
        break;
      case '*':
        sum *= value;
        break;
      case '/':
        sum ~/= value;
        break;
    }
  }
  return sum;
}

String _formatResult(String roll, List<int> rolls,
    List<(String, int)> modifiers, int sum, bool hasNat20, bool hasNat1,
    [String option = "", List<int>? secondRoll]) {

  final modifiersString = modifiers.map((m) => "${m.$1} ${m.$2}").join(" ");
  final optionString = option != ''
      ? " with ${option.toLowerCase() == 'a' ? "advantage" : "disadvantage"}"
      : "";
  final nat20Message = hasNat20 ? ' with a nat 20!' : '';
  final nat1Message = hasNat1 ? ' with a critical 1!' : '';
  final secondRollString =
      secondRoll ?? "";

  return '$roll$optionString: $rolls $secondRollString $modifiersString = $sum $nat20Message$nat1Message';
}

//END DND HELPERS

/// Rolls dice for a generic system (no specific rules).
String rollNone(String roll) {
  List<int> rolls = [];
  var sum = 0;

  int numberOfDice = int.parse(roll.substring(0, roll.indexOf("d")));
  int sidesOfDice = int.parse(roll.substring(roll.indexOf("d") + 1));
  rolls = rollHelper(numberOfDice: numberOfDice, numberOfSides: sidesOfDice);
  sum = rolls.reduce((value, element) => value + element);

  return '$rolls = $sum';
}

/// Helper function to perform dice rolls.
///
/// Takes `numberOfDice` and `numberOfSides` as parameters and returns a list of the results.
List<int> rollHelper({required int numberOfDice, required int numberOfSides}) {
  List<int> roll = [];

  for (int i = 0; i < numberOfDice; i++) {
    roll.add((rng.nextInt(numberOfSides) + 1));
  }

  print(roll);
  return roll;
}
