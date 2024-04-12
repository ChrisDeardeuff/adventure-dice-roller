import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../services/user_services.dart';
import '../models/systems.dart';

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
  (ChatContext context, [String? selection]) async {
    var user = us.registerUser(context.user.id);
    var system = user.selectedSystem;

    List<int> rolls = [];
    var sum = 0;
    var rollPattern = RegExp(r'\b[0-9]{1,6}d{1}[0-9]{1,6}');
    switch (system) {
      case System.none:
        if (selection == null || !rollPattern.hasMatch(selection)) {
          await context.respond(
              MessageBuilder(
                  content:
                      'Invalid input! For the current selected system: none, the roll needs to be formatted as - /roll xdy (where x is number of dice and y is sides of dice)'),
              level: hiddenMessage);
          return;
        }

        int numberOfDice =
            int.parse(selection.substring(0, selection.indexOf("d")));
        int sidesOfDice =
            int.parse(selection.substring(selection.indexOf("d") + 1));
        rolls =
            rollHelper(numberOfDice: numberOfDice, numberOfSides: sidesOfDice);
        sum = rolls.reduce((value, element) => value + element);

        await context.respond(MessageBuilder(content: '$rolls = $sum'));
        return;

      case System.asoif:
        rollPattern = RegExp(r'\b[0-9]{1,6}b{1}[0-9]{1,6}');

        if (selection == null || !rollPattern.hasMatch(selection)) {
          await context.respond(
              MessageBuilder(
                  content:
                      'Invalid input! For the current selected system: asoif, the roll needs to be formatted as - /roll xby (where x is number of dice and y is number of bonus dice)'),
              level: hiddenMessage);
          return;
        }

        int numberOfDice =
            int.parse(selection.substring(0, selection.indexOf("b")));
        int numberOfBonusDice =
            int.parse(selection.substring(selection.indexOf("b") + 1));

        //roll base dice and bonus dice
        rolls = rollHelper(
            numberOfDice: numberOfDice + numberOfBonusDice, numberOfSides: 6);
        //sort in descending order
        rolls.sort((b, a) => a.compareTo(b));
        //take only the top x rolls
        var finalRolls = rolls.take(numberOfDice).toList();
        //sum the top x rolls
        var sum = finalRolls.reduce((value, element) => value + element);

        await context.respond(MessageBuilder(
            content:
                'Rolled: ${rolls.toString()}. The highest $numberOfDice is: $finalRolls = $sum'));
        return;

      case System.age:
        rollPattern = RegExp(r'^\d$');

        if (selection == null || !rollPattern.hasMatch(selection)) {
          await context.respond(
              MessageBuilder(
                  content:
                      'Invalid input! For the current selected system: age, the roll needs to be formatted as - /roll x is the value you would like to add to your 3d6 (0-9).'),
              level: hiddenMessage);
          return;
        }

        int attMod = int.parse(selection);

        //roll base dice
        rolls = rollHelper(numberOfDice: 3, numberOfSides: 6);

        //sum the rolls and add mod
        var sum = rolls.reduce((value, element) => value + element) + attMod;

        // Convert the list to a Set (Sets only store unique values)
        Set<int> uniqueNumbers = rolls.toSet();

        // Check if the original list and set have different lengths
        bool hasDuplicates = uniqueNumbers.length != rolls.length;

        if(hasDuplicates){
          await context.respond(MessageBuilder(
              content: 'Rolled: ${rolls.toString()} + $attMod = $sum and generated ${rolls.last} stunt points!'));
          return;
        }else{
          await context.respond(MessageBuilder(
              content: 'Rolled: ${rolls.toString()} + $attMod = $sum'));
          return;
        }
      case System.dnd:
      // TODO: Handle this case.
    }
  },
);

List<int> rollHelper({required int numberOfDice, required int numberOfSides}) {
  List<int> roll = [];

  for (int i = 0; i < numberOfDice; i++) {
    roll.add(rng.nextInt(numberOfSides) + 1);
  }

  return roll;
}
