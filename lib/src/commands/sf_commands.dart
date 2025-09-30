import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../server.dart';
import '../models/sf_scores.dart';

/// Logger for roll-related events and errors.
final Logger _logger = Logger('ADR.SFCommands');

/// Provides user data and operations.
UserServices us = UserServices();

final setSFS = ChatCommand(
  'set-stillfleet-scores',
  "Set Stillfleet System Character Scores",
  id(
    'set-stillfleet-scores',
    (ChatContext context,
        [String? CHA,
        String? COM,
        String? REA,
        String? MOV,
        String? WIL]) async {
      if (CHA == null ||
          COM == null ||
          REA == null ||
          MOV == null ||
          WIL == null) {
        await context.respond(MessageBuilder(
            content: "All fields must be filled, and must be valid numbers."));
        return;
      }

      try {
        _logger.info("Parsing: CHA - $CHA, COM - $COM, REA - $REA, MOV - $MOV, WIL - $WIL");
        _logger.info(Dice.d4.name);
        Dice cha = Dice.values.firstWhere((e) => e.name == CHA);
        Dice com = Dice.values.firstWhere((e) => e.name == COM);
        Dice rea = Dice.values.firstWhere((e) => e.name == REA);
        Dice mov = Dice.values.firstWhere((e) => e.name == MOV);
        Dice wil = Dice.values.firstWhere((e) => e.name == WIL);

        var user = await us.registerUser(context.user.id);

        us.setSFScores(cha,com,rea,mov,wil,user);

      }catch(e){
        _logger.info("Error setting scores: $e");
        await context.respond(MessageBuilder(
            content: "Error setting scores. Make sure all fields are in dx format (where x is 4, 6, 8, 10, or 12"));
        return;
      }


      await context.respond(MessageBuilder(
          content:
              'Scores set successfully: CHA - $CHA, COM - $COM, REA - $REA, MOV - $MOV, WIL - $WIL'));
      return;
    },
  ),
);
