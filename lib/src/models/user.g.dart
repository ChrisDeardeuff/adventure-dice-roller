// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ADRUser _$ADRUserFromJson(Map<String, dynamic> json) => ADRUser(
      _snowflakeFromJson(json['id']),
    )
      ..selectedSystem = $enumDecode(_$SystemEnumMap, json['selectedSystem'])
      ..quickRolls = const ListOfQuickRollsConverter()
          .fromJson(json['quickRolls'] as String)
      ..stillfleetScores =
          SFScores.fromJson(json['stillfleetScores'] as Map<String, dynamic>);

Map<String, dynamic> _$ADRUserToJson(ADRUser instance) => <String, dynamic>{
      'selectedSystem': _$SystemEnumMap[instance.selectedSystem]!,
      'id': _snowflakeToJson(instance.id),
      'quickRolls':
          const ListOfQuickRollsConverter().toJson(instance.quickRolls),
      'stillfleetScores': instance.stillfleetScores.toJson(),
    };

const _$SystemEnumMap = {
  System.none: 'none',
  System.asoif: 'asoif',
  System.age: 'age',
  System.dnd: 'dnd',
  System.sf: 'sf',
};
