import 'dart:convert';

import 'package:adventure_dice_roller/src/models/quick_roll.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

import '../models/systems.dart';

class ListOfQuickRollsConverter extends JsonConverter<List<QuickRoll>, String> {
  const ListOfQuickRollsConverter();

  @override
  List<QuickRoll> fromJson(String json) {
    final Logger logger = Logger('ADR.QRConverter');
    logger.info('decoding QR..');

    List<dynamic> decodedList = jsonDecode(json);
    List<QuickRoll> lqr = [];

    for (int i = 0; i < decodedList.length; i++) {
      Map<String, dynamic> entry = decodedList[i];

      QuickRoll newQR = QuickRoll(System.values[i]);
      newQR.savedQuickRolls =
          (entry['savedQuickRolls'] as List<dynamic>).cast<String>();
      lqr.add(newQR);
    }

    return lqr;
  }

  @override
  String toJson(List<QuickRoll> object) {
    return jsonEncode(object);
  }
}
