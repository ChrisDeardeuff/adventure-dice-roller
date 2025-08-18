// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sf_scores.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SFScores _$SFScoresFromJson(Map<String, dynamic> json) => SFScores()
  ..scores = (json['scores'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, $enumDecodeNullable(_$DiceEnumMap, e)),
  );

Map<String, dynamic> _$SFScoresToJson(SFScores instance) => <String, dynamic>{
      'scores': instance.scores.map((k, e) => MapEntry(k, _$DiceEnumMap[e])),
    };

const _$DiceEnumMap = {
  Dice.d4: 0,
  Dice.d8: 1,
  Dice.d10: 2,
  Dice.d12: 3,
  Dice.d20: 4,
};
