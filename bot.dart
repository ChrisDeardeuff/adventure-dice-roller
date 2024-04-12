import "package:nyxx_commands/src/context/chat_context.dart"
    as package_nyxx_commands__src__context__chat_context___dart;
import "dart:core" as dart_core;
import 'package:nyxx_commands/src/mirror_utils/mirror_utils.dart';
import 'file:///home/chris/IdeaProjects/adventure-dice-roller/bin/server.dart'
    as _main show main;
import "dart:core";

// Auto-generated file
// DO NOT EDIT

// Function data

const Map<dynamic, FunctionData> functionData = {
  'ping': FunctionData([
    ParameterData(
      name: "context",
      type: const RuntimeType<
          package_nyxx_commands__src__context__chat_context___dart
          .ChatContext>.allowingDynamic(),
      isOptional: false,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
  ]),
  'roll': FunctionData([
    ParameterData(
      name: "context",
      type: const RuntimeType<
          package_nyxx_commands__src__context__chat_context___dart
          .ChatContext>.allowingDynamic(),
      isOptional: false,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
    ParameterData(
      name: "selection",
      type: const RuntimeType<dart_core.String?>.allowingDynamic(),
      isOptional: true,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
  ]),
  'systems': FunctionData([
    ParameterData(
      name: "context",
      type: const RuntimeType<
          package_nyxx_commands__src__context__chat_context___dart
          .ChatContext>.allowingDynamic(),
      isOptional: false,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
  ]),
  'set-system': FunctionData([
    ParameterData(
      name: "context",
      type: const RuntimeType<
          package_nyxx_commands__src__context__chat_context___dart
          .ChatContext>.allowingDynamic(),
      isOptional: false,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
  ]),
  'get-system': FunctionData([
    ParameterData(
      name: "context",
      type: const RuntimeType<
          package_nyxx_commands__src__context__chat_context___dart
          .ChatContext>.allowingDynamic(),
      isOptional: false,
      description: null,
      defaultValue: null,
      choices: null,
      converterOverride: null,
      autocompleteOverride: null,
      localizedDescriptions: null,
      localizedNames: null,
    ),
  ]),
};
// Main function wrapper
void main(List<String> args) {
  loadData(functionData);

  _main.main();
}
