import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluro/fluro.dart';
import 'dart:io';

const String Last_Login = 'last_login';
const String User_Locale = 'user_locale';

const String AdmobId_Android = "ca-app-pub-2118868664212790~5542322408";
const String AdmobId_Ios = "ca-app-pub-2118868664212790~6161269507";

class Application {
  factory Application() => _getInstance();

  static Application get instance => _getInstance();

  static Application _instance;

  static Application _getInstance() {
    if (_instance == null) {
      _instance = Application._();
    }
    return _instance;
  }

  static Router router;

  Application._() {
    // 初始化
    print(
        '****************************************$debug****************************************************');
    this.openDate = DateTime.now();
    initApp();
  }
  //是否显示广告
  bool showAd = false;
  //是否显示引导页
  bool showGuide = false;
  //上一次打开时间
  DateTime lastOpen;
  //打开时间
  DateTime openDate;

  Locale locale = Locale('en');

  static final String version = '1.2';
  //
  static final bool debug = bool.fromEnvironment("dart.vm.product") != true;

  static final bool ios = Platform.isIOS;

  static var env;

  initApp() async {
    var initAd = await FirebaseAdMob.instance
        .initialize(appId: Platform.isAndroid ? AdmobId_Android : AdmobId_Ios);
    print('initAd -> $initAd');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var last = prefs.get(Last_Login);
    if (last == null) {
      showGuide = true;
    } else {
      showAd = true;
    }
    if (Application.debug) {
      showAd = false;
      showGuide = false;
    }
    prefs.setString(Last_Login, this.openDate.toIso8601String());
    locale = Locale(prefs.get(User_Locale));
  }

  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class MColors {
  static String pink = 'e382c0';
}
