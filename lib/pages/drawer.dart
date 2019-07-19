import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pm/config/application.dart';
import 'package:provider/provider.dart';
import 'package:pm/provider/user.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';

class ListItem {
  const ListItem({
    @required this.title,
    this.icon,
    this.subtitle,
    @required this.routeName,
  })  : assert(title != null),
        assert(routeName != null);

  final String title;
  final IconData icon;
  final String subtitle;
  final String routeName;
}

List<ListItem> items = [
  ListItem(
    title: "actions.intr",
    icon: Icons.info,
    routeName: 'intr',
  ),
  ListItem(
    title: "actions.help",
    icon: Icons.help,
    routeName: 'help',
  ),
  ListItem(
    title: "actions.about",
    icon: Icons.portrait,
    routeName: 'about',
  ),
];

class DrawerPage extends StatefulWidget {
  DrawerPage({this.stateCallback, Key key}) : super(key: key);
  final stateCallback;
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool _isLoading = false;

  _createItems(context) {
    return items.map((i) {
      Widget trailing;
      if (i.routeName == 'about') {
        trailing = Text('v.${Application.version}');
      }
      return ListTile(
          leading: Icon(i.icon),
          title: Text(FlutterI18n.translate(context, i.title)),
          onTap: () {
            Application.router.navigateTo(context, i.routeName);
          },
          trailing: trailing);
    }).toList();
  }

  _loginIn(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<User>(context).loginIn((res) {
      setState(() {
        _isLoading = false;
      });
      showToast(
        FlutterI18n.translate(context, res),
        duration: Duration(seconds: 3),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.9),
        radius: 8.0,
        textStyle: TextStyle(fontSize: 18.0),
      );
    });
  }

  _changeLanguage(BuildContext context) async {
    Locale local = FlutterI18n.currentLocale(context);
    await FlutterI18n.refresh(
        context, Locale(local.languageCode == 'en' ? 'zh' : 'en'));
    Application.instance.locale = FlutterI18n.currentLocale(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        Constants.userLocale, Application.instance.locale.languageCode);
    setState(() {});
  }

  @override
  void initState() {
    widget.stateCallback('init');
    super.initState();
  }

  @override
  void dispose() {
    widget.stateCallback('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    User user = Provider.of<User>(context);
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Stack(children: [
              if (user.isLogin)
                UserAccountsDrawerHeader(
                  accountName: Text(user.displayName),
                  accountEmail: Row(children: <Widget>[
                    Expanded(flex: 7, child: Text(user.email)),
                    Expanded(
                        child: Text(
                          FlutterI18n.translate(context, 'score') +
                              ':' +
                              user.score.toString(),
                        ),
                        flex: 3),
                  ]),
                  currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl)),
                ),
              if (!user.isLogin)
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 300.0,
                  child: Center(
                    child: MaterialButton(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset('assets/imgs/google.png'),
                          Text(
                            FlutterI18n.translate(context, 'login.google'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _loginIn(context);
                      },
                    ),
                  ),
                ),
              // SafeArea(
              Positioned(
                top: padding.top,
                right: 10.0,
                width: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    _changeLanguage(context);
                  },
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    Application.instance.locale.languageCode == 'en'
                        ? '中'
                        : 'En',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF0385ec),
                ),
              ),
              // )
            ]),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _createItems(context),
            ),
            SizedBox(
              height: 10,
            ),
            if (user.isLogin)
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  minWidth: double.infinity,
                  child: Text(
                    FlutterI18n.translate(context, 'login.out'),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: user.loginOut,
                ),
              ),
            if (Application.debug)
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.red,
                    child: Text(
                      FlutterI18n.translate(context, 'actions.clear'),
                    ),
                    onPressed: () {
                      Application.clear();
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
