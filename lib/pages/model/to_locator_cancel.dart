import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/config.dart';

import '../../theme.dart';

class ToLocatorCancel {
  static Future<ToLocatorCancel> connectToApi(String id, String user) async {
    var baseUrl = Config.url;

    String apiUrl = "$baseUrl/my_locator/backend/web/postdata/bataltransaksi";

    try {
      var apiResult = await http.post(apiUrl, body: {
        "id": id,
        "user": user,
      });

      var jsonData = json.decode(apiResult.body);
      String status = jsonData['data']['status'];

      if (apiResult.statusCode == 200) {
        if (status == "sukses") {
          print('draft is cancelled');
        }
      } else {
        print("gagal");
        throw Exception('Failed to request data.');
      }
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) {
        print("error catch : " + e.toString());
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
