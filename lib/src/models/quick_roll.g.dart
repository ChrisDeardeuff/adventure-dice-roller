// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickRoll _$QuickRollFromJson(Map<String, dynamic> json) => QuickRoll(
      $enumDecode(_$SystemEnumMap, json['selectedSystem']),
    )..savedQuickRolls = (json['savedQuickRolls'] as List<dynamic>)
        .map((e) => e as String)
        .toList();

Map<String, dynamic> _$QuickRollToJson(QuickRoll instance) => <String, dynamic>{
      'selectedSystem': _$SystemEnumMap[instance.selectedSystem]!,
      'savedQuickRolls': instance.savedQuickRolls,
    };

const _$SystemEnumMap = {
  System.none: 'none',
  System.asoif: 'asoif',
  System.age: 'age',
  System.dnd: 'dnd',
};
