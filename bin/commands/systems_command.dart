import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../services/user_services.dart';
import '../models/systems.dart';

UserServices us = UserServices();
final hiddenMessage = ResponseLevel(hideInteraction: true, isDm: false, mention: true, preserveComponentMessages: true);
final systems = ChatCommand(
  'systems',
  "List available systems",
  (ChatContext context) async {
    String sysList = "";
    for (var system in System.values) {
      sysList = "$sysList ${system.name},";
    }
    await context.respond(MessageBuilder(content: sysList),level: hiddenMessage);
  },
);

final setSystem = ChatCommand(
  'set-system',
  "Set current user's active system",
  (ChatContext context) async {
    final selection = await context.getSelection(
      System.values.map((e) => e.name).toList(),
      MessageBuilder(content: 'Choose the system you want to use'),
    );

    var user = us.registerUser(context.user.id);

    switch(selection){

      case "none":
        user.selectedSystem = System.none;
      case "asoif":
        user.selectedSystem = System.asoif;
      case "age":
        user.selectedSystem = System.age;
      case "dnd":
        user.selectedSystem = System.dnd;
    }
    await context.respond(MessageBuilder(content: "System Set to $selection!"),level: hiddenMessage);
  },
);

final getSystem = ChatCommand(
  'get-system',
  "get current user's active system",
      (ChatContext context) async {

    var user = us.registerUser(context.user.id);
    await context.respond(MessageBuilder(replyId:user.id, content: "System Set to ${user.selectedSystem.name}!"),level: hiddenMessage);
  },
);
