import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/config.dart';

import '../../theme.dart';

class ToLocatorPost {
  static Future<ToLocatorPost> connectToApi(String toSubInv, String toLoc,
      String id, String qtyTrf, String user, String noMoveOrder) async {
    var baseUrl = Config.url;

    String apiUrl = "$baseUrl/my_locator/backend/web/postdata/transaksi";

    try {
      var apiResult = await http.post(apiUrl, body: {
        "to_sub_inv": toSubInv,
        "to_loc": toLoc,
        "id": id,
        "qty_trf": qtyTrf,
        "user": user,
        "no_moveorder": noMoveOrder,
      });

      var jsonData = json.decode(apiResult.body);
      String status = jsonData['data']['status'];

      if (apiResult.statusCode == 200) {
        if (status == "sukses") {
          print('insert transfer to locator success');
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
