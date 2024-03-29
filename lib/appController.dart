import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singscan/appService.dart';
import 'package:singscan/models/concert.dart';
import 'package:singscan/models/login.dart';
import 'package:singscan/models/user.dart';

class AppController extends ChangeNotifier {
  late SharedPreferences prefs;

  final AppService appService;
  // FirebaseMessaging? messaging;

  String? token;
  User? user;
  AppController({this.appService = const AppService()}) {
    //messaging = FirebaseMessaging.instance;
  }
  List<Concert> concerts = [];
  Concert? concert;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    try {
      user = token != null ? await appService.getProfile() : null;
    } catch (e) {
      await prefs.clear();
      initialize();
    }

    notifyListeners();
  }

  Future<void> clearToken() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    user = null;
    token = null;

    notifyListeners();
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> signIn({
    required String tel,
    required String password,
  }) async {
    final data = await AppService.Login(tel, password);
    final SharedPreferences prefs = await _prefs;

    if (data != null) {
      final _user = Login.fromJson(data['data']);
      await prefs.setString('token', data['data']['access_token']);
      await prefs.setString('uid', data['data']['user']['id']);
      return true;
    }
    return false;
    //return User.fromJson(data['user']);
  }

  getAllConcerts() async {
    concerts.clear();
    concerts = await AppService.getConcerts();
    notifyListeners();
  }

  getConcertId(String id) async {
    concert = await AppService.getConcertsById(id);
    notifyListeners();
  }

  // Future<void> setToken() async {
  //   final String? webToken = await messaging?.getToken();
  //   print(webToken);
  //   await appService.setToken(webToken!);
  // }
}
