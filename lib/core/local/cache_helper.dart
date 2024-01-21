import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setData(key, value) async {
    switch (value.runtimeType) {
      case bool:
        return sharedPreferences.setBool(key, value);
      case String:
        return await sharedPreferences.setString(key, value);
      default:
        String dataString = convert.jsonEncode(value);
        return await sharedPreferences.setString(key.toString(), dataString);
    }
  }

  static getData(key, Type type) async {
    try {
      switch (type) {
        case bool:
          return sharedPreferences.getBool(key);
        case String:
          return sharedPreferences.getString(key);
        case Map:
          String? data = sharedPreferences.getString(key.toString());
          if (data != null) {
            return await convert.jsonDecode(data);
          } else {
            return null;
          }
      }

      // ignore: empty_catches
    } catch (e) {}
  }

  static removeData(key) async {
    try {
      sharedPreferences.remove(key);
      // ignore: empty_catches
    } catch (e) {}
  }

  static removeAllData() async {
    try {
      sharedPreferences.clear();
      // ignore: empty_catches
    } catch (e) {}
  }
}
