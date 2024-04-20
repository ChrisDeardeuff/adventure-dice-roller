import 'package:json_annotation/json_annotation.dart';
import 'systems.dart';

part 'quick_roll.g.dart';

@JsonSerializable()
class QuickRoll {
  System selectedSystem;

  List<String> savedQuickRolls = [
    'empty',
    'empty',
    'empty',
    'empty',
    'empty',
    'empty',
    'empty',
    'empty',
    'empty',
    'empty'
  ];

  ///A Quick Roll Object represents all saved quick rolls of a system for a specified user
  QuickRoll(this.selectedSystem);

  /// setQuickRoll adds a provided roll (string) to the provided index - 1 (1-10);
  setQuickRoll(int index, String roll) {
    savedQuickRolls[index - 1] = roll;
  }

  /// geQuickRolls gets a provided roll (string) from the provided index - 1 (1-10);
  String getQuickRoll(int index) {
    return savedQuickRolls[index - 1];
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory QuickRoll.fromJson(Map<String, dynamic> json) =>
      _$QuickRollFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$QuickRollToJson(this);
}
