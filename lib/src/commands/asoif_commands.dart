import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final attack = ChatCommand(
    'attack',
    "Calculate an attack in the ASOIF RPG system.",
    id(
      'attack',
      (ChatContext context,
          [int? roll,
          int? numberOfSixes,
          int? baseDamage,
          int? targetsCombatDefense,
          int? targetsArmorRating]) async {
        if (roll == null ||
            baseDamage == null ||
            targetsCombatDefense == null ||
            targetsArmorRating == null) {
          await context.respond(MessageBuilder(
              content:
                  "All fields must be filled, and must be valid numbers."));
          return;
        }

        var isCrit = (roll >= 2 * targetsArmorRating);
        var degreesOfSuccess = ((roll - targetsCombatDefense) / 5).floor();
        var critEffect = "";
        var damageDealt = 0;

        if (degreesOfSuccess > 4) {
          degreesOfSuccess == 4;
        }

        if (isCrit) {
          switch (numberOfSixes) {
            case 1:
              baseDamage += 2;
            case 2:
              baseDamage += 4;
            case 3:
              critEffect = " and add an injury!";
            case 4:
              critEffect = " and add a wound!";
            case 5:
              critEffect = " and they are dead!";
            case 6:
              critEffect =
                  " and deal your base damage of $baseDamage to surrounding enemy!";
            case 7:
              critEffect = " and all allies gain +1B on all tests";
            case 8:
              critEffect = " and read the book please I can't type this";
          }

          damageDealt = (baseDamage * degreesOfSuccess) - targetsArmorRating;
          await context.respond(MessageBuilder(
              content:
                  'An attack of $roll (with $numberOfSixes) is $degreesOfSuccess degrees of success and is a critical strike, resulting in $damageDealt damage $critEffect'));
          return;
        } else {
          damageDealt = (baseDamage * degreesOfSuccess) - targetsArmorRating;
          await context.respond(MessageBuilder(
              content:
                  'An attack of $roll is $degreesOfSuccess degrees of success, resulting in $damageDealt damage'));
          return;
        }
      },
    ));
