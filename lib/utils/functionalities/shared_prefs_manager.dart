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

  static Future<void> setUID(String uid)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.userId, uid);
  }

  static Future<String> getUID()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstant.userId)??'';
  }

  static Future<void> setProfileName(String name)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.userName, name);
  }

  static Future<String> getUserName()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstant.userName)??'';
  }

  static Future<void> setProfilePhotoLink(String link)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.profilePhotoLink, link);
  }

  static Future<String> getProfilePhotoLink()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstant.profilePhotoLink)??'';
  }
}