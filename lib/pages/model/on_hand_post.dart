import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/config.dart';

import '../../theme.dart';

class OnHandPost {
  String rownum;
  String lotNumber;
  String locator;
  String transQty;
  String uom;
  String ed;
  String status;
  String manufacture;
  String supplier;

  OnHandPost({
    this.rownum,
    this.lotNumber,
    this.locator,
    this.transQty,
    this.uom,
    this.ed,
    this.status,
    this.manufacture,
    this.supplier,
  });

  factory OnHandPost.resultPostOnHand(Map<String, dynamic> json) {
    return OnHandPost(
      rownum: json['ROWNUM'],
      lotNumber: json['LOT_NUMBER'],
      locator: json['LOKASI'],
      transQty: json['TRANSACTION_QUANTITY'],
      uom: json['PRIMARY_UOM_CODE'],
      ed: json['EXPIRATION_DATE'],
      status: json['STATUS_CODE'],
      manufacture: json['MANUFACTURE'],
      supplier: json['KETERANGAN'],
    );
  }

  static Future<List<OnHandPost>> connectToApi(
      String subInv, String kodeItem, String orgId) async {
    var baseUrl = Config.url;
    String apiUrl = "$baseUrl/my_locator/backend/web/postdata/reportonhand";

    try {
      var apiResult = await http.post(apiUrl, body: {
        "sub_inv": subInv,
        "kode_item": kodeItem,
        "org_id": orgId,
      });

      if (apiResult.statusCode == 200) {
        List jsonOnject = json.decode(apiResult.body);
        List<OnHandPost> listOnHandPost = [];
        for (int i = 0; i < jsonOnject.length; i++) {
          listOnHandPost.add(OnHandPost.resultPostOnHand(jsonOnject[i]));
        }
        // print(jsonOnject);
        return listOnHandPost;
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
