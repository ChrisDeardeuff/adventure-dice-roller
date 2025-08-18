import 'package:adventure_dice_roller/src/converters/list_qr_converter.dart';
import 'package:adventure_dice_roller/src/models/quick_roll.dart';
import 'package:adventure_dice_roller/src/converters/snowflake_json_converter.dart';
import 'package:adventure_dice_roller/src/models/sf_scores.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

import 'systems.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class ADRUser {
  System selectedSystem = System.none;

  @JsonKey(fromJson: _snowflakeFromJson, toJson: _snowflakeToJson)
  Snowflake id;

  @ListOfQuickRollsConverter()
  List<QuickRoll> quickRolls = [];

  SFScores stillfleetScores = SFScores();

  ADRUser(this.id) {
    for (var system in System.values) {
      quickRolls.add(QuickRoll(system));
    }
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ADRUser.fromJson(Map<String, dynamic> json) =>
      _$ADRUserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ADRUserToJson(this);
}

// Helper functions used by @JsonKey to avoid casts in generated code
Snowflake _snowflakeFromJson(Object? json) {
  return const SnowflakeJsonConverter().fromJson(json?.toString() ?? '');
}

String _snowflakeToJson(Snowflake value) {
  return const SnowflakeJsonConverter().toJson(value);
}
