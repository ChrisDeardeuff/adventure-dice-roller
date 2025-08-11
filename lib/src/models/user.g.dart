// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ADRUser _$ADRUserFromJson(Map<String, dynamic> json) => ADRUser(
      const SnowflakeJsonConverter().fromJson(json['id'].toString()),
    )
      ..selectedSystem = $enumDecode(_$SystemEnumMap, json['selectedSystem'])
      ..quickRolls = const ListOfQuickRollsConverter()
          .fromJson(json['quickRolls'] as String);

Map<String, dynamic> _$ADRUserToJson(ADRUser instance) => <String, dynamic>{
      'selectedSystem': _$SystemEnumMap[instance.selectedSystem]!,
      'id': const SnowflakeJsonConverter().toJson(instance.id),
      'quickRolls':
          const ListOfQuickRollsConverter().toJson(instance.quickRolls),
    };

const _$SystemEnumMap = {
  System.none: 'none',
  System.asoif: 'asoif',
  System.age: 'age',
  System.dnd: 'dnd',
};
