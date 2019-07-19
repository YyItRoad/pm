import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pm/config/application.dart';
import '../utils/http.dart';
import 'drawer.dart';
import 'dart:convert';

enum RefreshState {
  None,
  Refresh,
  LoadMore,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _sc;
  List list = new List();
  int page = 1;
  bool isPerformingRequest = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _sc = ScrollController();
    _sc.addListener(() {
      if (_sc.position.pixels >= (_sc.position.maxScrollExtent - 50)) {
        _getMoreData();
      }
    });
    _getData();
    super.initState();
  }

  Future _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      page++;
      var response = await HttpUtil().get({'page': page});
      if (response.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom =
            _sc.position.maxScrollExtent - _sc.position.pixels;
        if (offsetFromBottom < edge) {
          _sc.animateTo(_sc.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      }
      setState(() {
        list.addAll(response['hits']);
        isPerformingRequest = false;
      });
    }
  }

  Future _getData() async {
    page = 1;
    var response = await HttpUtil().get({'page': page});
    setState(() {
      isPerformingRequest = false;
      list = response['hits'];
    });
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var item = list[index];
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Application.router.navigateTo(context,
              '/photo?heroId=Hero$index&data=${base64Encode(utf8.encode(json.encode(item)))}');
        },
        child: Hero(
          tag: 'Hero$index',
          child: Container(
            width: double.infinity,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                image: NetworkImage(item['previewURL']),
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/imgs/loading.gif'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.face),
        onPressed: () {
          Application.router.navigateTo(context, 'fish');
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'app.name')),
        actions: actions,
      ),
      drawer: Drawer(child: DrawerPage(
        stateCallback: (state) {
          // print('Drawer State ->$state');
        },
      )),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            if (index == list.length) {
              return _buildProgressIndicator();
            } else {
              return _itemBuilder(context, index);
            }
          },
          controller: _sc,
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
