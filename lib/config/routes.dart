import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:pm/pages/actions.dart';
import 'package:pm/pages/card.dart';
import 'package:pm/pages/fish.dart';
import 'package:pm/pages/home.dart';
import 'package:pm/pages/photo.dart';
import 'package:pm/pages/splash.dart';
import 'dart:convert';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String intr = "/intr";
  static String about = "/about";
  static String photo = "/photo";
  static String help = "/help";
  static String card = "/card";
  static String fish = "/fish";

  static void configureRoutes(Router router) {
    router.notFoundHandler =
        new Handler(handlerFunc: (BuildContext context, Map params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root,
        handler: Handler(
            handlerFunc: (BuildContext context, Map params) => SplashPage()));
    router.define(home,
        handler: Handler(
            handlerFunc: (BuildContext context, Map params) => HomePage()));
    router.define(intr,
        handler: Handler(
            handlerFunc: (BuildContext context, Map params) => IntrPage()));
    router.define(help,
        handler: Handler(
            handlerFunc: (BuildContext context, Map params) => HelpPage()));
    router.define(about,
        handler: Handler(
            handlerFunc: (BuildContext context, Map params) => AboutPage()));
    router.define(
      photo,
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
            PhotoPage(
          heroId: params['heroId']?.first,
          data: json.decode(
              String.fromCharCodes(base64Decode(params['data']?.first))),
        ),
      ),
    );
    router.define(card,
        handler: Handler(handlerFunc: (context, parameters) => CardPage()));
    router.define(fish,
        handler: Handler(handlerFunc: (context, parameters) => FishPage()));
  }
}
