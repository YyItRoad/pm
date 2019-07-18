import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:oktoast/oktoast.dart';
import 'provider/user.dart';
import 'config/application.dart';
import 'config/routes.dart';

void main() async {
  Application();
  final router = new Router();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => User()),
      ],
      child: OKToast(
        child: MaterialApp(
          title: 'Picture Master',
          onGenerateRoute: Application.router.generator,
          navigatorObservers: [observer],
          localizationsDelegates: [
            FlutterI18nDelegate(
                useCountryCode: false,
                fallbackFile: Application.instance.locale.languageCode,
                path: 'assets/i18n'),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
        ),
      ),
    );
  }
}
