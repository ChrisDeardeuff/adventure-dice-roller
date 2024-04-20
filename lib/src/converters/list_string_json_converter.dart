import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

class ListOfStringConverter extends JsonConverter<List<String>, String> {
  const ListOfStringConverter();

  @override
  List<String> fromJson(String json) {
    final Logger logger = Logger('ADR.LSConverter');
    logger.info('decoding List..');

    List<dynamic> decodedList = jsonDecode(json);
    return decodedList.cast<String>();
  }

  @override
  String toJson(List<String> object) {
    return jsonEncode(object);
  }
}
