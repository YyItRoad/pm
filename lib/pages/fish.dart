import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pm/config/ad.dart';
import 'package:pm/config/application.dart';
import 'package:pm/provider/user.dart';
import 'package:provider/provider.dart';

class FishPage extends StatefulWidget {
  @override
  _FishPageState createState() => _FishPageState();
}

class _FishPageState extends State<FishPage> with WidgetsBindingObserver {
  InAppWebViewController webView;

  bool delay = false;
  User user;
  bool _hud = false;
  RewardedVideoAd _ad;
  Map fishTimes = Map();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    Future.delayed(
        Duration(milliseconds: 100),
        () => setState(() {
              delay = true;
            }));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      user.updateFishScore();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    user.updateFishScore();
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  _showToast(msg) {
    showToast(
      FlutterI18n.translate(context, msg),
      duration: Duration(seconds: 3),
      position: ToastPosition.center,
      backgroundColor: Colors.black.withOpacity(0.9),
      radius: 8.0,
      textStyle: TextStyle(fontSize: 18.0),
    );
  }

  _showAd() {
    setState(() {
      _hud = true;
    });
    _ad = createVideoAd((RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        _ad.show();
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        _showToast('ad.fail');
      } else if (event == RewardedVideoAdEvent.completed) {
      } else if (event == RewardedVideoAdEvent.rewarded) {
        user.addScore(rewardAmount);
        _addCoin(rewardAmount * (Application.debug ? 1 : 30), type: true);
        _showToast('ad.success');
      }

      if (event == RewardedVideoAdEvent.loaded ||
          event == RewardedVideoAdEvent.failedToLoad) {
        setState(() {
          _hud = false;
        });
      }
    });
  }

  _showAdDialog(String title, String subTitle, {Map<String, String> ext}) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FlutterI18n.translate(context, title)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(FlutterI18n.translate(context, subTitle, ext)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(FlutterI18n.translate(context, 'actions.confirm')),
              onPressed: () {
                _showAd();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(FlutterI18n.translate(context, 'actions.cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _initJSHander(webView) {
    webView.addJavaScriptHandler('coin', (args) {
      var coin = args[0], need = args[1];
      user.fishScore = coin;
      if (need != null) {
        _showAdDialog("coin.lack", "ad.watch", ext: {"coins": "300"});
      }
    });
    webView.addJavaScriptHandler('fish', (args) {
      var fish = args[0];
      int times = fishTimes[fish] ??= 0;
      times++;
      fishTimes[fish] = times;
      if (fish == 10 && times % 5 == 0) {
        _showAdDialog('tips.gx', 'fish.have', ext: {"fish": "5"});
      }
    });
    webView.addJavaScriptHandler('game', (args) {
      var state = args[0];
      if (state == 'complete') {
      } else if (state == 'ready') {
        return json.encode({
          'coin': user.fishScore,
          'lng': Application.instance.locale.languageCode,
        });
      }
      return {};
    });
  }

  _addCoin(coin, {bool type}) {
    if (type) {
      user.fishScore += coin;
    }
    webView.injectScriptCode("window.Inject.addCoin($coin)");
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    Widget child;
    if (delay) {
      child = InAppWebView(
        initialFile: "assets/fish.html",
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
          _initJSHander(controller);
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          setState(() {});
        },
        onConsoleMessage:
            (InAppWebViewController controller, ConsoleMessage consoleMessage) {
          debugPrint("""
              console output:
                message: ${consoleMessage.message}
                messageLevel: ${consoleMessage.messageLevel}
                lineNumber: ${consoleMessage.lineNumber}
                sourceURL: ${consoleMessage.sourceURL}
              """);
        },
      );
    } else {
      child = Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _hud,
        child: Stack(
          children: <Widget>[
            child,
            Positioned(
              top: 28,
              left: 8,
              child: FloatingActionButton(
                tooltip: 'Close',
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  Application.router.pop(context);
                },
                heroTag: 'close',
                mini: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
