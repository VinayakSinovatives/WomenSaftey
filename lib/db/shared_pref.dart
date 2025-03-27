import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference{

  static SharedPreferences?_preferences;
  static const String key='usertype';

  static init() async{
    _preferences =await SharedPreferences.getInstance();
    return _preferences;
  }

 static Future saveUserType(String type)async{
    return await _preferences!.setString(key, type);
  }

  static Future< String> getUserType()async=> 
  await _preferences!.getString(key)??"";
}


/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;
  static const String key = 'usertype';

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save user type
  static Future<void> saveUserType(String type) async {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    await _preferences!.setString(key, type);
  }

  // Get user type
  static Future<String> getUserType() async {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    return _preferences!.getString(key) ?? "";
  }
}*/
