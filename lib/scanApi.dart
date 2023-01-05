import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singscan/constants.dart';

class ScanApi {
  const ScanApi();

  static Future getScanTicket(
      String ticketId, String concertId, String concertShowId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {'Authorization': 'Bearer $token'};
    final url = Uri.https(publicUrl, 'api/scan-ticket');
    final response = await http.post(url, headers: headers, body: {
      "ticketId": ticketId,
      "concertId": concertId,
      "concertShowId": concertShowId
    });

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 400) {
      final data = convert.jsonDecode(response.body);
      return data;
    }else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}
