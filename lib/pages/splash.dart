import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:pm/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/ad.dart';
import '../config/application.dart';
import '../swiper.dart';

enum _SplashState { Init, Guide, AD }

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _SplashState state = _SplashState.Init;

  List<String> _guideList = [
    'assets/imgs/page_1.jpg',
    'assets/imgs/page_2.jpg',
    'assets/imgs/page_3.jpg',
  ];

  _goMain() {
    Application.router.navigateTo(
      context,
      'home',
      replace: true,
      clearStack: true,
    );
  }

  _judeUserLocale(Locale locale) async {
    String lng = locale.languageCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localeCode = prefs.getString(Constants.userLocale);
    if (localeCode == null) {
      prefs.setString(Constants.userLocale, lng);
    } else if (localeCode != lng) {
      locale = Locale(localeCode);
      await FlutterI18n.refresh(context, locale);
    }
    Application.instance.locale = locale;
    debugPrint('MyApp locale --> ${Application.instance.locale}');
  }

  @override
  void initState() {
    super.initState();
    _judeUserLocale(FlutterI18n.currentLocale(context));
    _initAsync();
  }

  void _initAsync() async {
    if (Application.instance.showAd) {
      setState(() {
        state = _SplashState.AD;
      });
      createInterstitialAd((MobileAdEvent event) {
        if (event == MobileAdEvent.closed ||
            event == MobileAdEvent.failedToLoad) {
          _goMain();
        }
      })
        ..load()
        ..show();
    } else if (Application.instance.showGuide) {
      setState(() {
        state = _SplashState.Guide;
      });
    } else {
      Future.delayed(Duration(seconds: 3), () => _goMain());
    }
  }

  List<Widget> _initBannerData() {
    List<Widget> _bannerList = List();
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(
          new Stack(
            children: <Widget>[
              new Image.asset(
                _guideList[i],
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 160.0),
                  child: InkWell(
                    onTap: () {
                      _goMain();
                    },
                    child: CircleAvatar(
                      radius: 48.0,
                      backgroundColor: Colors.indigoAccent,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          FlutterI18n.translate(context, 'enter'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        _bannerList.add(new Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }

    return _bannerList;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SafeArea(
      child: Image.asset(
        'assets/imgs/splash_bg.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        height: double.infinity,
      ),
    );
    if (state == _SplashState.Guide) {
      child = new Swiper(
          autoStart: true,
          interval: Duration(seconds: 5),
          circular: false,
          children: _initBannerData());
    }
    return Scaffold(body: Center(child: child), backgroundColor: Colors.white);
  }
}
