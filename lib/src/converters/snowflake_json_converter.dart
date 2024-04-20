import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

class SnowflakeJsonConverter extends JsonConverter<Snowflake, String> {
  const SnowflakeJsonConverter();

  @override
  Snowflake fromJson(String json) {
    return Snowflake.parse(json);
  }

  @override
  String toJson(Snowflake object) {
    return object.value.toString();
  }
}
