import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pm/config/application.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);

enum ScoreType { Login, Ad, Fish }

class User with ChangeNotifier {
  User() {
    _autoLogin();
  }

  bool isLogin = false;

  String uid;

  /// The name of the user.
  String displayName;

  /// The URL of the user’s profile photo.
  String photoUrl;

  /// The user’s email address.
  String email;

  /// The user's phone number.
  String phoneNumber;

  /// The user's score;
  int score = 0;

  int fishScore = 0;

  Map _data;

  addScore(int s) {
    this.score += s;
    this._updateScore(this.score);
  }

  updateFishScore() {
    this._updateScore(this.fishScore, key: 'fishScore');
  }

  _updateScore(int s, {String key}) async {
    if (key == null) key = 'score';
    this._data[key] = s;
    if (this.isLogin) {
      await Firestore.instance
          .collection('/user')
          .document(this.uid)
          .setData(this._data);
    }
  }

  _loadScore() {
    if (this.isLogin) {
      Firestore.instance
          .collection('user')
          .document(this.uid)
          .snapshots()
          .listen((DocumentSnapshot snap) {
        this._data = snap.data;
        this.score = snap.data['score'] ??= 0;
        this.fishScore = snap.data['fishScore'] ??= 0;
        debugPrint('user --> $displayName ${snap.data}');
        notifyListeners();
      });
    }
  }

  _autoLogin() async {
    _userInfo(await _auth.currentUser());
    this._loadScore();
  }

  _userInfo(FirebaseUser u) {
    this.isLogin = false;
    if (u != null) {
      this.uid = u.uid;
      this.displayName = u.displayName;
      this.photoUrl = u.photoUrl;
      this.email = u.email;
      this.phoneNumber = u.phoneNumber;
      this.isLogin = true;
    }
  }

  loginIn(callback) async {
    if (this.isLogin) return callback('tips.login.online');
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);

      _userInfo(user);
      this._loadScore();

      callback('tips.login.success');
      notifyListeners();
    } catch (e) {
      print(e);
      callback('tips.login.fail');
    }
  }

  loginOut() async {
    await _auth.signOut();
    if (!Application.debug) {
      await _googleSignIn.signOut();
    }
    this.isLogin = false;
    notifyListeners();
  }
}
