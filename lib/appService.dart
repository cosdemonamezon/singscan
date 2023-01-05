
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singscan/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:singscan/models/concert.dart';

class AppService {
  const AppService();

  static Login(String phoneNumber, String password) async {
    final url = Uri.https(publicUrl, 'api/auth/sign-in');
    final response = await http.post(url, body: {
      'phoneNumber': phoneNumber,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 401) {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
    return null;

    //return null;
  }

  Future setToken(String webToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.https(publicUrl, 'api/tokens');

    final body = {
      'token': webToken,
    };

    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return data['data'];
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //Get concerts
  static Future<List<Concert>> getConcerts() async {
    final url = Uri.https(publicUrl, 'api/concerts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Concert.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  //Get concerts by Id
  static Future<Concert> getConcertsById(String id) async {
    final url = Uri.https(publicUrl, 'api/concerts/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return Concert.fromJson(data['data']);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}