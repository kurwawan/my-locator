import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/config.dart';

import '../../theme.dart';

class FromLocatorPost {
  static Future<FromLocatorPost> connectToApi(
      String itemCode,
      String lotNumber,
      String subInventory,
      /* int */ String organizationId,
      String uom,
      String deskripsi,
      /* double */ String quantity,
      String locator,
      /* int */ String user) async {
    var baseUrl = Config.url;
    String apiUrl = "$baseUrl/my_locator/backend/web/postdata/draft";

    try {
      var apiResult = await http.post(apiUrl, body: {
        "item_code": itemCode,
        "lot_number": lotNumber,
        "sub_inventory": subInventory,
        "organization_id": organizationId,
        "uom": uom,
        "deskripsi": deskripsi,
        "quantity": quantity,
        "locator": locator,
        "user": user,
      });

      var jsonData = json.decode(apiResult.body);
      String status = jsonData['data']['status'];

      if (apiResult.statusCode == 200) {
        if (status == "sukses") {
          print('insert locator success');
        }
      } else {
        throw Exception('Failed to request data.');
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
