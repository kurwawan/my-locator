import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_locator/config.dart';
import 'package:my_locator/pages/menu/cancel_success.dart';
import 'package:my_locator/pages/menu/scanner_page.dart';
import 'package:my_locator/pages/menu/transaction_success.dart';
import 'package:my_locator/pages/model/log_post.dart';
import 'package:my_locator/pages/model/to_locator_cancel.dart';
import 'package:my_locator/pages/model/to_locator_post.dart';
import 'package:my_locator/theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ToLocatorPratimbangPage extends StatefulWidget {
  // const ToLocatorPratimbangPage({Key? key}) : super(key: key);
  @override
  _ToLocatorPratimbangPageState createState() =>
      _ToLocatorPratimbangPageState();
}

class _ToLocatorPratimbangPageState extends State<ToLocatorPratimbangPage> {
  var baseUrl = Config.url;
  String resultCode;
  bool isLoading = false,
      isVisible = true,
      isConnected = false,
      isLoadingToSubInv = false,
      isLoadingData = false,
      isLoadingButton = false,
      isButtonDisable;
  StreamSubscription sub;
  TextEditingController resultQuantity = new TextEditingController();
  TextEditingController resultNoMoveOrder = new TextEditingController();

  String resultPersonId;
  Future getPersonId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      resultPersonId = sharedPreferences.getString('personId');
    });
  }

  String valId;
  List<dynamic> dataItem = List();
  Future getItem() async {
    String apiItem = "$baseUrl/my_locator/backend/web/getdata/listlocator";

    try {
      final response = await http.get(apiItem);
      var listDataItem = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          dataItem = listDataItem;
        });
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

  String resultKodeItem,
      resultDesc,
      resultLotNum,
      resultOrgId,
      resultIdLoc,
      resultFromSubInv,
      resultQty,
      resultUom,
      resultLocDesc;
  Future getDataItem($id) async {
    String apiDataItem =
        "$baseUrl/my_locator/backend/web/getdata/locatorbyid?id=" + $id;
    try {
      final apiResult = await http.get(apiDataItem);
      if (apiResult.statusCode == 200) {
        var data = json.decode(apiResult.body);
        setState(() {
          resultKodeItem = data[0]['ITEM_CODE'];
          resultDesc = data[0]['DESCRIPTION'];
          resultLotNum = data[0]['LOT_NUMBER'];
          resultOrgId = data[0]['ORGANIZATION_ID'];
          resultIdLoc = data[0]['LOCATOR_ID'];
          resultFromSubInv = data[0]['SUBINVENTORY_CODE'];
          resultQty = data[0]['TRANSACTION_QUANTITY'];
          resultUom = data[0]['TRANSACTION_UOM'];
          resultLocDesc = data[0]['LOCATOR_DES'];
        });
      } else {
        throw Exception('Faield to request data');
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

  String valSubInv;
  List<dynamic> dataSubInv = List();
  Future getSubInv(String id) async {
    String apiSubInv =
        "$baseUrl/my_locator/backend/web/getdata/subinv?id=" + id;

    try {
      final response = await http.get(apiSubInv);
      var listDataSubInv = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {
          dataSubInv = listDataSubInv;
        });
      }
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

  String valLocPratimbang;
  List<dynamic> dataLocPratimbang = List();
  Future getLocPratimbang() async {
    String apiLocPratimbang =
        "$baseUrl/my_locator/backend/web/getdata/listsubinvpratimbang";

    try {
      final response = await http.get(apiLocPratimbang);
      var listDataLocPratimbang = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {
          dataLocPratimbang = listDataLocPratimbang;
        });
      }
      if (response.statusCode == 200) {
        if (dataLocPratimbang?.isNotEmpty ?? false) {
        } else {
          print('LOC PRATIMBANG KOSONG');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isButtonDisable = false;
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none &&
            result != ConnectivityResult.mobile);
        if (isConnected) {
          getPersonId();
          isLoading = true;
          isVisible = false;
          getItem().whenComplete(() {
            isLoading = false;
          }).catchError((e) {
            print(e.toString());
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => DrawerPage())); */
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: isConnected
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : dataItem.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.not_listed_location_sharp,
                              size: 150,
                              color: primaryColor,
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Text(
                              'Draft Kosong !',
                              style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                'To Locator Pratimbang',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                // height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: thirdColor,
                                  hint: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Pilih item',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: primaryColor,
                                  ),
                                  iconSize: 28,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  value: valId,
                                  items: dataItem.map((item) {
                                    if (dataItem.isEmpty) {
                                      return DropdownMenuItem(
                                        child: Text(''),
                                        value: null,
                                      );
                                    } else {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 0,
                                              left: 4.0,
                                            ),
                                            child: Text(item['ITEM_CODE']
                                                    .toString() +
                                                " | " +
                                                item['DES_SECOND'].toString() +
                                                " || " +
                                                item['LOCATOR_DES']),
                                          ),
                                        ),
                                        value: item['ID'].toString(),
                                      );
                                    }
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      valId = value;
                                      print(valId);
                                      isLoadingData = true;

                                      getDataItem(valId).whenComplete(() {
                                        getLocPratimbang().whenComplete(() {
                                          // isLoadingToSubInv = false;
                                          isLoadingData = false;
                                          dataSubInv = [];
                                        }).catchError((e) {
                                          print(e.toString());
                                        });
                                        resultQuantity.text =
                                            resultQty.toString();
                                      }).catchError((e) {
                                        print(e.toString());
                                      });

                                      isVisible = true;
                                      resultCode = null;
                                      resultQuantity.text = '';
                                      valSubInv = null;
                                      valLocPratimbang = null;
                                      dataLocPratimbang = [];
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isVisible,
                                child: isLoadingData
                                    ? Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(primaryColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text('Loading ...'),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 15.0,
                                                      right: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Kode Item',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultKodeItem
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Description',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              /* resultDesc.toString() */
                                                              (() {
                                                                if (resultDesc
                                                                        .toString()
                                                                        .contains(
                                                                            '~') ==
                                                                    true) {
                                                                  return resultDesc
                                                                      .substring(
                                                                          0,
                                                                          resultDesc
                                                                              .indexOf('~'));
                                                                } else {
                                                                  return resultDesc
                                                                      .toString();
                                                                }
                                                              })(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0, right: 2.5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Lot Number',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultLotNum
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Organization',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  /* Text(
                                                          resultOrgId.toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ), */
                                                                  Text(
                                                                (() {
                                                                  if (resultOrgId
                                                                          .toString() ==
                                                                      "82") {
                                                                    return "IFP";
                                                                  } else if (resultOrgId
                                                                          .toString() ==
                                                                      "86") {
                                                                    return "IFR";
                                                                  } else if (resultOrgId
                                                                          .toString() ==
                                                                      "88") {
                                                                    return "IFO";
                                                                  } else if (resultOrgId
                                                                          .toString() ==
                                                                      "92") {
                                                                    return "IFN";
                                                                  } else {
                                                                    return "";
                                                                  }
                                                                })(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0, right: 2.5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'From Locator',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultLocDesc
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'From Sub Inventory',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultFromSubInv
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0, right: 2.5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Quantity',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultQty
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'UOM',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: thirdColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              resultUom
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                            /* Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 25.0, right: 2.5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                child: Container(
                                                  height: 60,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      return _openScanner(
                                                          context);
                                                    },
                                                    color: primaryColor,
                                                    elevation: 5.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                    ),
                                                    child: Text(
                                                      'SCAN\nQR CODE',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: 25.0,
                                                  left: 2.5,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                        ), */
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Nomor Move Order',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Container(
                                                  // width: double.infinity,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: primaryColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Center(
                                                      child: TextField(
                                                        controller:
                                                            resultNoMoveOrder,
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        inputFormatters: [
                                                          WhitelistingTextInputFormatter(
                                                              RegExp(
                                                                  r"^\d+\d{0,6}")),
                                                        ],
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal: true),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Locator Pratimbang',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  // height: 35,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: primaryColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor: thirdColor,
                                                    hint: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Pilih item',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: primaryColor,
                                                    ),
                                                    iconSize: 28,
                                                    underline: SizedBox(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    value: valLocPratimbang,
                                                    items: dataLocPratimbang
                                                        .map((item) {
                                                      if (dataLocPratimbang
                                                          .isEmpty) {
                                                        return DropdownMenuItem(
                                                          child: Text(''),
                                                          value: null,
                                                        );
                                                      } else {
                                                        return DropdownMenuItem(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5,
                                                              bottom: 5,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 4.0,
                                                              ),
                                                              child: Text(item[
                                                                      'DESCRIPTION']
                                                                  .toString()),
                                                            ),
                                                          ),
                                                          value: item[
                                                                  'DESCRIPTION']
                                                              .toString(),
                                                        );
                                                      }
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        dataSubInv = [];
                                                        isLoadingToSubInv =
                                                            true;
                                                        valLocPratimbang =
                                                            value;
                                                        getSubInv(
                                                                valLocPratimbang)
                                                            .whenComplete(() {
                                                          isLoadingToSubInv =
                                                              false;
                                                          // isLoadingData = false;
                                                        }).catchError((e) {
                                                          print(e.toString());
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0, right: 2.5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Quantity Transfer',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'To Sub Inventory',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0, right: 2.5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          // width: double.infinity,
                                                          height: 65,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child: Center(
                                                              child: TextField(
                                                                controller:
                                                                    resultQuantity,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                inputFormatters: [
                                                                  WhitelistingTextInputFormatter(
                                                                      RegExp(
                                                                          r"^\d+\.?\d{0,6}")),
                                                                ],
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
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
                                                      left: 2.5,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          // width: double.infinity,
                                                          height: 65,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child: Center(
                                                              child: isLoadingToSubInv
                                                                  ? DropdownButton(
                                                                      isExpanded:
                                                                          true,
                                                                      hint:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Text(
                                                                          'Loading ...',
                                                                          style:
                                                                              TextStyle(fontSize: 25),
                                                                        ),
                                                                      ),
                                                                      dropdownColor:
                                                                          thirdColor,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_drop_down,
                                                                        color:
                                                                            primaryColor,
                                                                      ),
                                                                      iconSize:
                                                                          28,
                                                                      underline:
                                                                          SizedBox(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            25,
                                                                      ),
                                                                      value:
                                                                          null,
                                                                      items:
                                                                          null,
                                                                      onChanged:
                                                                          null,
                                                                    )
                                                                  : DropdownButton(
                                                                      isExpanded:
                                                                          true,
                                                                      hint:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Text(
                                                                          '',
                                                                          style:
                                                                              TextStyle(fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      dropdownColor:
                                                                          thirdColor,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_drop_down,
                                                                        color:
                                                                            primaryColor,
                                                                      ),
                                                                      iconSize:
                                                                          28,
                                                                      underline:
                                                                          SizedBox(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            25,
                                                                      ),
                                                                      value:
                                                                          valSubInv,
                                                                      items: dataSubInv
                                                                          .map(
                                                                              (item) {
                                                                        if (dataSubInv
                                                                            .isEmpty) {
                                                                          return DropdownMenuItem(
                                                                            child:
                                                                                Text(''),
                                                                            value:
                                                                                null,
                                                                          );
                                                                        } else {
                                                                          return DropdownMenuItem(
                                                                            child:
                                                                                Text(item['SUBINVENTORY_CODE']),
                                                                            value:
                                                                                item['SUBINVENTORY_CODE'],
                                                                          );
                                                                        }
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          valSubInv =
                                                                              value;
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
                                                top: 15,
                                                bottom: 20,
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      width: double.maxFinite,
                                                      height: 55,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: fifthColor,
                                                          textStyle: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          /* minimumSize: Size.fromHeight(72), */
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0),
                                                          ),
                                                        ),
                                                        child: Text('CANCEL'),
                                                        onPressed:
                                                            isButtonDisable
                                                                ? null
                                                                : () async {
                                                                    setState(
                                                                        () {
                                                                      isButtonDisable =
                                                                          true;
                                                                    });
                                                                    showAlertDialog(
                                                                        context);
                                                                  },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      width: double.maxFinite,
                                                      height: 55,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: primaryColor,
                                                          textStyle: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          /* minimumSize: Size.fromHeight(72), */
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0),
                                                          ),
                                                        ),
                                                        child: isLoadingButton
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 25,
                                                                    width: 25,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<Color>(
                                                                              fourthColor),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    'Menyimpan',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text('SAVE'),
                                                        onPressed:
                                                            isButtonDisable
                                                                ? null
                                                                : () async {
                                                                    /* print(resultPersonId.toString() +
                                                          " => " +
                                                          resultKodeItem.toString() +
                                                          " => " +
                                                          resultDesc.toString() +
                                                          " => " +
                                                          resultLotNum.toString() +
                                                          " => " +
                                                          resultOrgId.toString() +
                                                          " => " +
                                                          resultIdLoc.toString() +
                                                          " => " +
                                                          resultFromSubInv.toString() +
                                                          " => " +
                                                          resultQty.toString() +
                                                          " => " +
                                                          resultUom.toString() +
                                                          " => " +
                                                          resultCode.toString() +
                                                          " => " +
                                                          resultQuantity.text +
                                                          " => " +
                                                          valSubInv.toString()); */
                                                                    if (valId == null ||
                                                                        resultQuantity.text ==
                                                                            '' ||
                                                                        valLocPratimbang ==
                                                                            null ||
                                                                        valSubInv ==
                                                                            null ||
                                                                        double.parse(resultQuantity.text) ==
                                                                            double.parse(
                                                                                '0') ||
                                                                        resultNoMoveOrder.text ==
                                                                            '' ||
                                                                        int.parse(resultNoMoveOrder.text) ==
                                                                            int.parse('0')) {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Tidak boleh ada yang kosong",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .SNACKBAR,
                                                                          timeInSecForIosWeb:
                                                                              15,
                                                                          backgroundColor:
                                                                              fourthColor,
                                                                          textColor: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14.0);
                                                                    } else if (double.parse(resultQuantity
                                                                            .text) >
                                                                        double.parse(
                                                                            resultQty.toString())) {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Quantity lebih besar dibanding Stok On-Hand",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .SNACKBAR,
                                                                          timeInSecForIosWeb:
                                                                              15,
                                                                          backgroundColor:
                                                                              fifthColor,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14.0);
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        isButtonDisable =
                                                                            true;
                                                                        isLoadingButton =
                                                                            true;
                                                                      });
                                                                      ToLocatorPost.connectToApi(
                                                                              valSubInv.toString(),
                                                                              valLocPratimbang.toString(),
                                                                              valId,
                                                                              resultQuantity.text,
                                                                              resultPersonId,
                                                                              resultNoMoveOrder.text)
                                                                          .then((e) {
                                                                        print("success e : " +
                                                                            e.toString());

                                                                        LogPost.connectToApi(
                                                                            'Transfer Draft',
                                                                            'To Locator: $valLocPratimbang, Description: $resultDesc, Lot Number: $resultLotNum, From Locator: $resultLocDesc, From Sub Inv: $resultFromSubInv, To Sub Inv: $valSubInv, Org Id: $resultOrgId, UOM: $resultUom, Quantity: $resultQty, Transfer Qty: ' +
                                                                                resultQuantity.text,
                                                                            resultPersonId);

                                                                        setState(
                                                                            () {
                                                                          isButtonDisable =
                                                                              false;
                                                                          isLoadingButton =
                                                                              false;
                                                                        });

                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => TrasanctionSuccessPage(
                                                                                      data: "PRATIMBANG",
                                                                                    )));
                                                                      }).catchError((e) {
                                                                        print("error : " +
                                                                            e.toString());
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              false;
                                                                          isLoadingButton =
                                                                              false;
                                                                          isButtonDisable =
                                                                              false;
                                                                        });
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Koneksi server terputus",
                                                                            toastLength: Toast
                                                                                .LENGTH_SHORT,
                                                                            gravity: ToastGravity
                                                                                .SNACKBAR,
                                                                            timeInSecForIosWeb:
                                                                                15,
                                                                            backgroundColor:
                                                                                fifthColor,
                                                                            textColor:
                                                                                Color(0xffffffff),
                                                                            fontSize: 14.0);
                                                                      });
                                                                    }
                                                                  },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 70,
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('KONEKSI WIFI TERPUTUS',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  /* Future _openScanner(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => ScannerPage()));
    setState(() {
      valSubInv = null;
      dataSubInv = [];
      // resultQuantity.text = '';
      resultCode = result;
      if (resultCode != null) {
        isLoadingToSubInv = true;
        getSubInv(resultCode).whenComplete(() {
          isLoadingToSubInv = false;
        }).catchError((e) {
          print(e.toString());
        });
      } else {
        valSubInv = null;
        // resultQuantity.text = '';
      }
    });
  } */

  showAlertDialog(BuildContext context) {
    setState(() {
      isButtonDisable = false;
    });
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Tidak",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: fifthColor,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          isButtonDisable = false;
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Ya",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      onPressed: () {
        ToLocatorCancel.connectToApi(valId, resultPersonId).whenComplete(() {
          LogPost.connectToApi(
              'Cancel Draft',
              'From Locator: $resultLocDesc, Description: $resultDesc, Lot Number: $resultLotNum, From Sub Inv: $resultFromSubInv, Org Id: $resultOrgId, UOM: $resultUom, Quantity: $resultQty',
              resultPersonId);
        }).catchError((e) {
          print(e.toString());
        });

        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CancelSuccess(
                      data: "PRATIMBANG",
                    )));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancel draft ?"),
      // content: Text("Cancel draft?"),
      actions: [
        cancelButton,
        SizedBox(
          width: 15,
        ),
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
