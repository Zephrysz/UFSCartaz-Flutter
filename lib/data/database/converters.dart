import 'package:floor/floor.dart';
import 'dart:convert';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class ListIntConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    return List<int>.from(json.decode(databaseValue));
  }

  @override
  String encode(List<int> value) {
    return json.encode(value);
  }
} 