import 'package:shared_preferences/shared_preferences.dart';

import '../values/app_constant.dart';

class SharedPrefsManager{

  static Future<void> setSplash(bool status)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.loggedIn, status);
  }

  static Future<bool> getSplashStatus()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstant.loggedIn)??false;
  }
}