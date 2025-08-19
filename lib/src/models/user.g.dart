// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ADRUser _$ADRUserFromJson(Map<String, dynamic> json) => ADRUser(
      _snowflakeFromJson(json['id']),
    )
      ..selectedSystem = $enumDecode(_$SystemEnumMap, json['selectedSystem'])
      ..quickRolls = (json['quickRolls'] as List<dynamic>)
          .map((e) => QuickRoll.fromJson(e as Map<String, dynamic>))
          .toList()
      ..stillfleetScores = _sfScoresFromJson(json['stillfleetScores']);

Map<String, dynamic> _$ADRUserToJson(ADRUser instance) => <String, dynamic>{
      'selectedSystem': _$SystemEnumMap[instance.selectedSystem]!,
      'id': _snowflakeToJson(instance.id),
      'quickRolls': instance.quickRolls.map((e) => e.toJson()).toList(),
      'stillfleetScores': instance.stillfleetScores.toJson(),
    };

const _$SystemEnumMap = {
  System.none: 'none',
  System.asoif: 'asoif',
  System.age: 'age',
  System.dnd: 'dnd',
  System.sf: 'sf',
};
