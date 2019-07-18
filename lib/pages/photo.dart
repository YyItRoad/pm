import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:oktoast/oktoast.dart';

Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
  var data = await getNetworkImageData(url, useCache: useCache);
  var filePath = await ImagePickerSaver.saveFile(fileData: data);
  return filePath != null && filePath != "";
}

enum Download { None, Downloading, Downloaded }

class PhotoPage extends StatefulWidget {
  final String heroId;
  final Map data;

  PhotoPage({
    @required this.heroId,
    @required this.data,
  });

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  Download _state = Download.None;
  RewardedVideoAd rewardedVideoAd;
  RewardedVideoAdEvent _adEvent;

  @override
  void initState() {
    super.initState();
  }

  _downloadPhoto() async {
    setState(() {
      _state = Download.Downloading;
    });
    bool res = false;
    try {
      res = await saveNetworkImageToPhoto(widget.data['largeImageURL']);
    } catch (e) {}
    setState(() {
      _state = res ? Download.Downloaded : Download.None;
    });
    showToast(
      FlutterI18n.translate(
          context, res ? "tips.save.success" : "tips.save.fail"),
      duration: Duration(seconds: 3),
      position: ToastPosition.center,
      backgroundColor: Colors.black.withOpacity(0.9),
      radius: 8.0,
      textStyle: TextStyle(fontSize: 18.0),
    );
  }

  Widget myBody(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.heroId,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: FadeInImage(
                image: NetworkImage(widget.data['largeImageURL']),
                fit: BoxFit.cover,
                placeholder: NetworkImage(widget.data['previewURL']),
              ),
            ),
          ),
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
                Navigator.pop(context);
              },
              heroTag: 'close',
              mini: true,
              backgroundColor: themeData.primaryColor.withOpacity(0.5),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height - 150,
                    ),
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeData.primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 16.0, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.data['userImageURL'],
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  widget.data['user'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_state != Download.Downloaded)
                    Positioned(
                      right: 16.0,
                      top: 0.0,
                      child: FloatingActionButton(
                        backgroundColor: themeData.primaryColor,
                        child: Icon(
                          Icons.file_download,
                          color: Colors.white,
                        ),
                        onPressed: _downloadPhoto,
                      ),
                    )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _state == Download.Downloading,
      child: myBody(context),
    );
  }
}
