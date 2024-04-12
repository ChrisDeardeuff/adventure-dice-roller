import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final ping = ChatCommand(
  'ping',
  "Get the bot's latency",
  id('ping',(ChatContext context) async {
    final selection = await context.getSelection(
      ['Basic', 'Real', 'Gateway'],
      MessageBuilder(content: 'Choose the latency metric you want to see'),
    );

    final latency = switch (selection) {
      'Basic' => context.client.httpHandler.latency,
      'Real' => context.client.httpHandler.realLatency,
      'Gateway' => context.client.gateway.latency,
      _ => throw StateError('Unexpected selection $selection'),
    };

    final formattedLatency =
    (latency.inMicroseconds / Duration.microsecondsPerMillisecond).toStringAsFixed(3);

    await context.respond(MessageBuilder(content: '${formattedLatency}ms'));
  },
));