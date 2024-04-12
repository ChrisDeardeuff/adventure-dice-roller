import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final roll = ChatCommand(
  'roll',
  "default roll for selected system",
      (ChatContext context, [String? selection]) async {

        var system = "none";
        var rng = Random();
        List<int> rolls = [];
        var sum = 0;

        switch(system){
          case "none":
            int numberOfDice = int.parse(selection!.substring(0,selection.indexOf("d")));
            int sidesOfDice = int.parse(selection.substring(selection.indexOf("d")+1));
            for(int i = 0; i<numberOfDice; i++){
              var roll = rng.nextInt(sidesOfDice)+1;
              sum = sum + roll;
              rolls.add(roll);

            }
        }
        await context.respond(MessageBuilder(content: '${rolls} = ${sum}'));
  },
);