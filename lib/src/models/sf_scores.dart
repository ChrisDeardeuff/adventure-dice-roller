import 'package:json_annotation/json_annotation.dart';

part 'sf_scores.g.dart';

@JsonSerializable()
class SFScores {
  Map<String, Dice?> scores = {
    'COM': null,
    'MOV': null,
    'REA': null,
    'WIL': null,
    'CHA': null,
  };

  SFScores();

  factory SFScores.fromJson(Map<String, dynamic> json) =>
      _$SFScoresFromJson(json);

  Map<String, dynamic> toJson() => _$SFScoresToJson(this);

}
enum Dice {
  @JsonValue(0)
  d4,
  @JsonValue(1)
  d6,
  @JsonValue(2)
  d8,
  @JsonValue(3)
  d10,
  @JsonValue(4)
  d12
}
