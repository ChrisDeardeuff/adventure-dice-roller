import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../server.dart';
import '../models/systems.dart';

final Logger _logger = Logger('ADR.SystemRolls');

final systems = ChatCommand(
    'systems',
    "List available systems",
    id(
      'systems',
      (ChatContext context) async {
        String sysList = "";
        for (var system in System.values) {
          sysList = "$sysList ${system.name},";
        }
        await context.respond(MessageBuilder(content: sysList),
            level: hiddenMessage);
      },
    ));

final setSystem = ChatCommand(
    'set-system',
    "Set current user's active system",
    id(
      'set-system',
      (ChatContext context) async {
        final selection = await context.getSelection(
          System.values.map((e) => e.name).toList(),
          MessageBuilder(content: 'Choose the system you want to use'),
        );

        var user = await us.registerUser(context.user.id);

        switch (selection) {
          case "none":
            user.selectedSystem = System.none;
          case "asoif":
            user.selectedSystem = System.asoif;
          case "age":
            user.selectedSystem = System.age;
          case "dnd":
            user.selectedSystem = System.dnd;
        }

        us.userSetSystem(user);

        await context.respond(
            MessageBuilder(content: "System Set to $selection!"),
            level: hiddenMessage);
      },
    ));

final getSystem = ChatCommand(
    'get-system',
    "get current user's active system",
    id(
      'get-system',
      (ChatContext context) async {
        _logger.info("get-system");
        var user = await us.registerUser(context.user.id);

        await context.respond(
            MessageBuilder(
                replyId: user.id,
                content: "System Set to ${user.selectedSystem.name}!"),
            level: hiddenMessage);
      },
    ));
