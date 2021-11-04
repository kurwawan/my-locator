import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/config.dart';

import '../../theme.dart';

class LogPost {
  static Future<LogPost> connectToApi(
      String aksi, String deskripsi, String user) async {
    var baseUrl = Config.url;

    String apiUrl = "$baseUrl/my_locator/backend/web/postdata/log";
    try {
      var apiResult = await http.post(apiUrl, body: {
        "action": aksi,
        "description": deskripsi,
        "user": user,
      });

      var jsonData = jsonDecode(apiResult.body);
      String status = jsonData['data']['status'];

      if (apiResult.statusCode == 200) {
        if (status == "log berhasil disimpan") {
          print('insert log success');
        }
      } else {
        throw Exception('Failed to request data');
      }
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        Fluttertoast.showToast(
            msg: "Koneksi server terputus",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 15,
            backgroundColor: fifthColor,
            textColor: Color(0xffffffff),
            fontSize: 14.0);
      }
    }
  }
}
