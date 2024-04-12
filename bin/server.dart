import 'package:adventure_dice_roller/server.dart';
import 'package:nyxx/nyxx.dart';
import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:nyxx_commands/nyxx_commands.dart';


void main() async {

  //load env variables
  var env = DotEnv(includePlatformEnvironment: true)..load();
  //register prefix for commands (Mention or !)
  final commands = CommandsPlugin(prefix: mentionOr((_)=>'!'));


  //add command to command list
  commands.addCommand(ping);
  commands.addCommand(roll);
  commands.addCommand(systems);
  commands.addCommand(setSystem);
  commands.addCommand(getSystem);

  //create the client with connection info
  final client = await Nyxx.connectGateway(
    env['API_TOKEN']!,
    GatewayIntents.messageContent,
    options: GatewayClientOptions(plugins: [logging, cliIntegration,commands]),
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