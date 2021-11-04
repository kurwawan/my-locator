import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_locator/config.dart';
import 'package:my_locator/pages/drawer.dart';
import 'package:my_locator/pages/drawer_fourth.dart';
import 'package:my_locator/pages/menu/scanner_page.dart';
import 'package:my_locator/pages/menu/to_locator.dart';
import 'package:my_locator/pages/menu/transaction_success.dart';
import 'package:my_locator/pages/model/log_post.dart';
import 'package:my_locator/pages/model/to_locator_post.dart';
import 'package:my_locator/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class ToLocatorTransferPage extends StatefulWidget {
  final String id,
      kodeItem,
      description,
      lotNumber,
      organizationId,
      idLocator,
      fromSubInv,
      qty,
      uom;
  ToLocatorTransferPage(
      {Key key,
      this.id,
      this.kodeItem,
      this.description,
      this.lotNumber,
      this.organizationId,
      this.idLocator,
      this.fromSubInv,
      this.qty,
      this.uom})
      : super(key: key);
  @override
  _ToLocatorTransferPageState createState() => _ToLocatorTransferPageState();
}

class _ToLocatorTransferPageState extends State<ToLocatorTransferPage> {
  String resultCode;
  var baseUrl = Config.url;
  String resultPersonId;
  bool isLoading = false, isButtonDisabled, isLoadingData = false;
  StreamSubscription sub;

  Future getPersonId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      resultPersonId = sharedPreferences.getString('personId');
    });
  }

  String valSubInv;
  List<dynamic> dataSubInv = List();
  Future getSubInv(String id) async {
    String apiSubInv =
        "$baseUrl/my_locator/backend/web/getdata/subinv?id=" + id;

    try {
      final response = await http.get(apiSubInv);
      var listDataSubInv = jsonDecode(response.body);
      setState(() {
        dataSubInv = listDataSubInv;
      });
      if (response.statusCode == 200) {
        if (dataSubInv?.isNotEmpty ?? false) {
          valSubInv = dataSubInv[0]['SUBINVENTORY_CODE'];
        } else {
          print('SUB INV KOSONG');
        }
      } else {
        dataSubInv.isEmpty;
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

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPersonId();
    isButtonDisabled = false;
  }

  TextEditingController resultQuantity = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Locator'),
        backgroundColor: primaryColor,
      ),
      body: isLoadingData
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'To Locator',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Kode Item',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.kodeItem,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 15.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Description',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Lot Number',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.lotNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Organization ID',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.organizationId,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ID Locator',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.idLocator,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'From Sub Inventory',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.fromSubInv,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Quantity',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.qty,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'UOM',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: thirdColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    widget.uom,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 25.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  return _openScanner(context);
                                },
                                color: primaryColor,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Text(
                                  'SCAN QR CODE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 25.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                resultCode != null
                                    ? resultCode
                                    : 'Hasil QR Code',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Quantity Transfer',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'To Sub Inventory',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: 8.0, left: 15.0, right: 5.0),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                // width: double.infinity,
                                height: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Center(
                                    child: TextField(
                                      controller: resultQuantity,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter(
                                            RegExp(r"^\d+\.?\d{0,6}")),
                                      ],
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 15.0,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                // width: double.infinity,
                                height: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      dropdownColor: thirdColor,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: primaryColor,
                                      ),
                                      iconSize: 28,
                                      underline: SizedBox(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                      ),
                                      value: valSubInv,
                                      items: dataSubInv.map((item) {
                                        if (dataSubInv.isEmpty) {
                                          return DropdownMenuItem(
                                            child: Text(''),
                                            value: null,
                                          );
                                        } else {
                                          return DropdownMenuItem(
                                            child:
                                                Text(item['SUBINVENTORY_CODE']),
                                            value: item['SUBINVENTORY_CODE'],
                                          );
                                        }
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          valSubInv = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 5.0,
                      bottom: 15.0,
                    ),
                    child: Container(
                      width: double.maxFinite,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          /* minimumSize: Size.fromHeight(72), */
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        fourthColor),
                                  ),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Text('Transfer Draft ...'),
                                ],
                              )
                            : Text('SAVE'),
                        onPressed: isButtonDisabled
                            ? null
                            : () async {
                                /* print(widget.id +
                        " => " +
                        widget.kodeItem +
                        " => " +
                        widget.description +
                        " => " +
                        widget.lotNumber +
                        " => " +
                        widget.organizationId +
                        " => " +
                        widget.idLocator +
                        " => " +
                        widget.fromSubInv +
                        " => " +
                        widget.qty +
                        " => " +
                        widget.uom +
                        " => " +
                        valSubInv +
                        " => " +
                        resultCode +
                        " => " +
                        resultQuantity.text +
                        " => " +
                        resultPersonId); */
                                String valDesc = widget.description,
                                    valLotNumber = widget.lotNumber,
                                    valOrgId = widget.organizationId,
                                    valUom = widget.uom,
                                    valQty = widget.qty,
                                    valFromSubInv = widget.fromSubInv,
                                    valIdLocator = widget.idLocator;

                                if (valSubInv == null ||
                                    resultQuantity.text == '' ||
                                    resultCode == null) {
                                  Fluttertoast.showToast(
                                      msg: "Tidak boleh ada yang kosong",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 15,
                                      backgroundColor: fourthColor,
                                      textColor: Colors.black,
                                      fontSize: 14.0);
                                } else if (double.parse(resultQuantity.text) >
                                    double.parse(widget.qty.toString())) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Quantity lebih besar dibanding Stok On-Hand",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 15,
                                      backgroundColor: fifthColor,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                } else {
                                  setState(() {
                                    isLoading = true;
                                    isButtonDisabled = true;
                                  });

                                  checkConnection().then((value) {
                                    if (value != null && value) {
                                      print("checkConnection: " +
                                          value.toString());
                                      ToLocatorPost.connectToApi(
                                              valSubInv,
                                              resultCode.toString(),
                                              widget.id,
                                              resultQuantity.text,
                                              resultPersonId,
                                              '')
                                          .then((e) {
                                        print("success e : " + e.toString());

                                        LogPost.connectToApi(
                                            'Transfer Draft',
                                            'QR Code: $resultCode, Description: $valDesc, Lot Number: $valLotNumber, ID Locator: $valIdLocator, From Sub Inv: $valFromSubInv, To Sub Inv: $valSubInv, Org Id: $valOrgId, UOM: $valUom, Quantity: $valQty, Transfer Qty: ' +
                                                resultQuantity.text,
                                            resultPersonId);

                                        // Navigator.of(context).pop(DrawerPage);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    TrasanctionSuccessPage()));
                                      }).catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                          isButtonDisabled = false;
                                        });
                                        print("error : " + e.toString());
                                      });
                                      /* Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DrawerFourthPage())); */
                                    } else {
                                      print("checkConnection: " +
                                          value.toString());
                                      setState(() {
                                        isLoading = false;
                                        isButtonDisabled = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Koneksi server terputus",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 15,
                                          backgroundColor: fifthColor,
                                          textColor: Color(0xffffffff),
                                          fontSize: 14.0);
                                    }
                                  });
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future _openScanner(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => ScannerPage()));
    setState(() {
      resultCode = result;
      resultQuantity.text = '';
      valSubInv = null;
      if (resultCode != null) {
        isLoadingData = true;
        getSubInv(resultCode).whenComplete(() {
          isLoadingData = false;
        }).catchError((e) {
          print(e);
          Text('Gagal loading ...');
        });
      }
    });
  }
}
