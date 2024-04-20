// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      const SnowflakeJsonConverter().fromJson(json['id'] as String),
    )
      ..selectedSystem = $enumDecode(_$SystemEnumMap, json['selectedSystem'])
      ..quickRolls = const ListOfQuickRollsConverter()
          .fromJson(json['quickRolls'] as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
