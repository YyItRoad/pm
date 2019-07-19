import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:pm/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluro/fluro.dart';
import '../env.dart';

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

  Locale locale;

  static final String version = '1.2.1';
  //
  static final bool debug = bool.fromEnvironment("dart.vm.product") != true;

  static var env;

  initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var last = prefs.get(Constants.lastLogin);
    if (last == null) {
      showGuide = true;
    } else {
      showAd = true;
    }
    if (Application.debug) {
      showAd = false;
      showGuide = false;
    }

    prefs.setString(Constants.lastLogin, this.openDate.toIso8601String());
    //初始化广告
    await FirebaseAdMob.instance.initialize(appId: Env.getAdmobId());
  }

  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class MColors {
  static String pink = 'e382c0';
}
