import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:singscan/constants.dart';

class ScanApi{
  const ScanApi();

  static Future getScanTicket(String id) async {
    final url = Uri.https(publicUrl, 'api/scan-ticket/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    }
    else if(response.statusCode == 400){
      final data = convert.jsonDecode(response.body);
      return data;
    }

    return null;
  }
}