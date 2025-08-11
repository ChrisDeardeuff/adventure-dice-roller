import 'dart:io';

import 'package:adventure_dice_roller/server.dart';
import 'package:adventure_dice_roller/src/commands/asoif_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

void main() async {
  UserServices us = UserServices();
  us.supaInit();

  //load env variables
  final apiToken = Platform.environment['API_TOKEN'];
  //register prefix for commands (Mention or !)
  final commands = CommandsPlugin(prefix: mentionOr((_) => '!'));

  //add command to command list
  commands.addCommand(ping);
  commands.addCommand(roll);
  commands.addCommand(systems);
  commands.addCommand(setSystem);
  commands.addCommand(getSystem);
  commands.addCommand(attack);
  commands.addCommand(setQr);
  commands.addCommand(qr);
  commands.addCommand(help);

  //create the client with connection info
  final client = await Nyxx.connectGateway(
    apiToken!,
    GatewayIntents.messageContent,
    options: GatewayClientOptions(plugins: [logging, cliIntegration, commands]),
  );

  final botUser = await client.users.fetchCurrentUser();

  //listen for a mention of
  client.onMessageCreate.listen((event) async {
    if (event.mentions.contains(botUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'Hi There!',
        replyId: event.message.id,
      ));
    }
  });
}
