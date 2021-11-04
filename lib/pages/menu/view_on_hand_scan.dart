import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_locator/config.dart';
import 'package:my_locator/theme.dart';
import 'package:my_locator/pages/menu/scanner_page.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_locator/pages/menu/view_on_hand_empty.dart';

class ViewOnHandScanPage extends StatefulWidget {
  // const ViewOnHandScanPage({Key? key}) : super(key: key);
  @override
  _ViewOnHandScanPageState createState() => _ViewOnHandScanPageState();
}

class _ViewOnHandScanPageState extends State<ViewOnHandScanPage> {
  String resultCode;
  var baseUrl = Config.url;
  String resultLotNumber,
      resultId,
      resultDesc,
      resultInvItemId,
      resultPersonId,
      resultDescSubstr,
      resultEd;
  bool isLoading = false,
      isButtonDisabled,
      isLoadingData = false,
      isConnected = false,
      isLoadingSubInv = false,
      isLoadingOrgId = false,
      isLoadingStockOnHand = false,
      isLoadingUom = false,
      isLoadingUomOnHand = false;
  StreamSubscription sub;
  TextEditingController resultQuantity = new TextEditingController();
  TextEditingController resultSearch = new TextEditingController();

  Future getPersonId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      resultPersonId = sharedPreferences.getString('personId');
    });
  }

  String valKodeItem;
  List<dynamic> dataKodeItem = List();
  Future getKodeItem(String id, String search) async {
    String apiKodeItem = "$baseUrl/my_locator/backend/web/getdata/item?id=" +
        id +
        "&search=" +
        search;

    try {
      final response = await retry(
        () => http.get(apiKodeItem),
      );

      if (response.statusCode == 200) {
        var listDataKodeItem = jsonDecode(response.body);
        if (this.mounted) {
          setState(() {
            dataKodeItem = listDataKodeItem;
          });
        }
        // print("data : $listDataKodeItem");
        if (dataKodeItem?.isNotEmpty ?? true) {
          // valKodeItem = dataKodeItem[0]['DES'];
          /* resultLotNumber = valKodeItem.substring(
            valKodeItem.indexOf('|| ') + 3, valKodeItem.length);
        resultId = valKodeItem.substring(0, 10);
        resultDesc = valKodeItem.substring(
            valKodeItem.indexOf('| ') + 2, valKodeItem.indexOf(' ||')); */

          /* getOnHand(resultId, resultLotNumber, resultCode).whenComplete(() {
          isLoadingStockOnHand = false;
          isLoadingUomOnHand = false;
        }).catchError((e) {
          print(e);
        });

        getSubInvOrgId(resultCode).whenComplete(() {
          isLoadingSubInv = false;
          isLoadingOrgId = false;
        }).catchError((e) {
          print(e);
        });

        getUom(resultCode).whenComplete(() {
          isLoadingUom = false;
        }).catchError((e) {
          print(e);
        });
      } else {
        getSubInvOrgId(resultCode).whenComplete(() {
          isLoadingSubInv = false;
          isLoadingOrgId = false;
        }).catchError((e) {
          print(e);
        });

        getUom(resultCode).whenComplete(() {
          isLoadingUom = false;
        }).catchError((e) {
          print(e);
        }); */

          isLoadingStockOnHand = false;
          isLoadingUomOnHand = false;
        } else {
          print('KODE ITEM KOSONG');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ViewOnHandIsEmptyPage()));
        }
      } else {
        dataKodeItem.isEmpty;
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
          fontSize: 14.0,
        );
      }
    }
  }

  String resultSubInv;
  /* Future getSubInv(String id) async {
    String apiSubInv =
        "$baseUrl/my_locator/backend/web/getdata/subinv?id=" + id;

    try {
      final response = await http.get(apiSubInv);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            resultSubInv = data[0]['SUBINVENTORY_CODE'];
          });
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
          fontSize: 14.0,
        );
      }
    }
  } */

  String valSubInv, valOrgId, valLocationId;
  List<dynamic> dataSubInvOrgId = List();
  Future getSubInvOrgId(String id) async {
    String apiSubInvOrgId =
        "$baseUrl/my_locator/backend/web/getdata/subinv?id=" + id;

    try {
      final response = await http.get(apiSubInvOrgId);
      var listDataSubInvOrgId = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {
          dataSubInvOrgId = listDataSubInvOrgId;
        });
      }
      // print("data : $listDataSubInvOrgId");
      if (response.statusCode == 200) {
        if (dataSubInvOrgId?.isNotEmpty ?? true) {
          if (valKodeItem == null) {
            dataSubInvOrgId = [];
            valSubInv = null;
            valOrgId = null;
            valLocationId = null;
          } else {
            valSubInv = dataSubInvOrgId[0]['SUBINVENTORY_CODE'];
            valOrgId = dataSubInvOrgId[0]['ORGANIZATION_ID'];
            valLocationId = dataSubInvOrgId[0]['INVENTORY_LOCATION_ID'];
          }
          // print('$valSubInv + $valOrgId + $valLocationId');
        } else {
          print('SUB INV - ORG ID KOSONG');
        }
      } else {
        dataSubInvOrgId.isEmpty;
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
          fontSize: 14.0,
        );
      }
    }
  }

  String valOnHandStock, valOnHandUom;
  Map<dynamic, dynamic> dataOnHand;
  Future getOnHand(String id, String usr, String loc) async {
    String apiOnHand = "$baseUrl/my_locator/backend/web/getdata/onhand?id=" +
        id +
        "&usr=" +
        usr +
        "&loc=" +
        loc;

    try {
      final response = await http.get(apiOnHand);
      if (this.mounted) {
        setState(() {
          dataOnHand =
              new Map<dynamic, dynamic>.from(jsonDecode(response.body));
        });
      }
      // print(dataOnHand.toString());
      if (response.statusCode == 200) {
        if (dataOnHand?.isNotEmpty ?? true) {
          valOnHandStock = dataOnHand['data']['PRIMARY_TRANSACTION_QUANTITY'];
          valOnHandUom = dataOnHand['data']['UOM'];
          resultInvItemId = dataOnHand['data']['INVENTORY_ITEM_ID'];
          /* print('On Hand Data:' +
          valOnHandStock.toString() +
          ' - ' +
          valOnHandUom.toString()); */
        } else {
          print('ON HAND KOSONG');
        }
      } else {
        dataOnHand.isEmpty;
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
          fontSize: 14.0,
        );
      }
    }
  }

  String valUom;
  List<dynamic> dataUom = List();
  Future getUom(String id) async {
    String apiUom = "$baseUrl/my_locator/backend/web/getdata/uom?id=" + id;

    try {
      final response = await http.get(apiUom);
      var listDataUom = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {
          dataUom = listDataUom;
        });
      }
      print("data : $listDataUom");
      if (dataUom?.isNotEmpty ?? false) {
        valUom = dataUom[0]['PRIMARY_UOM_CODE'];
      } else {
        print('UOM KOSONG');
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
          fontSize: 14.0,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none &&
            result != ConnectivityResult.mobile);
        if (isConnected) {
          getPersonId();
          isButtonDisabled = false;
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
    return Scaffold(
      body: isConnected
          ? isLoadingData
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Stock On Hand Scanner',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: RaisedButton(
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
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  resultCode != null
                                      ? resultCode
                                      : 'Hasil QR Code',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Cari nama item',
                                      border: InputBorder.none,
                                    ),
                                    controller: resultSearch,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      size: 35,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        valKodeItem = null;
                                        resultLotNumber = null;
                                        resultId = null;
                                        valSubInv = null;
                                        valOrgId = null;
                                        valOnHandStock = null;
                                        valOnHandUom = null;
                                        valUom = null;
                                        resultInvItemId = null;
                                        resultQuantity.text = '';
                                        valLocationId = null;
                                        resultDescSubstr = null;
                                        resultEd = null;
                                        resultSubInv = null;
                                        dataKodeItem = [];
                                        dataSubInvOrgId = [];
                                        dataUom = [];

                                        isLoadingData = true;
                                        // isLoadingSubInv = true;
                                        // isLoadingOrgId = true;
                                        // isLoadingStockOnHand = true;
                                        // isLoadingUom = true;
                                        // isLoadingUomOnHand = true;
                                      });

                                      getKodeItem(resultCode,
                                              resultSearch.text.toString())
                                          .whenComplete(() {
                                        print(resultSearch.text);
                                        isLoadingData = false;
                                      }).catchError((e) {
                                        print('e');
                                        Text('Gagal loading ...');
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Item',
                                style: TextStyle(
                                    color: primaryColor, fontSize: 14),
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
                                  value: valKodeItem,
                                  items: dataKodeItem.map((item) {
                                    if (dataKodeItem.isEmpty) {
                                      return DropdownMenuItem(
                                        child: Text(''),
                                        value: null,
                                      );
                                    } else {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            left: 4.0,
                                          ),
                                          child: Text(item['DES']
                                                  .substring(0, 10)
                                                  .toString() +
                                              " | " +
                                              item['DESCRIPTION'] +
                                              " || " +
                                              /* resultLotNumber.toString() */ item[
                                                  'LOT_NUMBER']),
                                        ),
                                        value: item['DES'],
                                      );
                                    }
                                  }).toList(),
                                  onChanged: isLoadingData
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    primaryColor),
                                          ),
                                        )
                                      : (value) {
                                          isLoadingData = true;
                                          setState(() {
                                            valKodeItem = value;

                                            resultLotNumber =
                                                valKodeItem.substring(
                                                    valKodeItem.indexOf('|| ') +
                                                        3,
                                                    valKodeItem
                                                        .indexOf(' |||'));
                                            resultId =
                                                valKodeItem.substring(0, 10);

                                            resultDesc = valKodeItem.substring(
                                                valKodeItem.indexOf('| ') + 2,
                                                valKodeItem.indexOf(' ||'));

                                            resultEd = valKodeItem.substring(
                                                valKodeItem.indexOf('||| ') + 4,
                                                valKodeItem.indexOf(' ||||'));

                                            resultSubInv =
                                                valKodeItem.substring(
                                                    valKodeItem
                                                            .indexOf('||||| ') +
                                                        5,
                                                    valKodeItem.length);

                                            if (resultDesc.contains('~') ==
                                                true) {
                                              resultDescSubstr =
                                                  resultDesc.substring(0,
                                                      resultDesc.indexOf('~'));
                                            } else {
                                              resultDescSubstr = resultDesc;
                                            }

                                            // getSubInv(resultCode);

                                            getOnHand(resultId, resultLotNumber,
                                                    resultCode)
                                                .whenComplete(() {
                                              isLoadingData = false;
                                            }).catchError((e) {
                                              print(e);
                                            });
                                          });

                                          getSubInvOrgId(resultCode)
                                              .whenComplete(() {})
                                              .catchError((e) {
                                            print(e.toString());
                                          });

                                          getUom(resultCode)
                                              .whenComplete(() {})
                                              .catchError((e) {
                                            print(e);
                                          });
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Kode Item',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
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
                                        color: thirdColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                resultId != null
                                                    ? resultId
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Nomor Lot',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
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
                                        color: thirdColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                resultLotNumber != null
                                                    ? resultLotNumber
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi Item',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 14),
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
                                color: thirdColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        resultDescSubstr != null
                                            ? resultDescSubstr
                                            : '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Sub Inventory',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: thirdColor,
                                      ),
                                      child:
                                          /* isLoadingSubInv
                                          ? DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: thirdColor,
                                              hint: Text(
                                                'Loading ...',
                                                style: TextStyle(fontSize: 16),
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
                                              value: null,
                                              items: null,
                                              onChanged: null,
                                            )
                                          : DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: thirdColor,
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
                                              value: valSubInv,
                                              items:
                                                  dataSubInvOrgId.map((item) {
                                                if (dataSubInvOrgId.isEmpty) {
                                                  return DropdownMenuItem(
                                                    child: Text(''),
                                                    value: null,
                                                  );
                                                } else {
                                                  return DropdownMenuItem(
                                                    child: Text(item[
                                                        'SUBINVENTORY_CODE']),
                                                    value: item[
                                                        'SUBINVENTORY_CODE'],
                                                  );
                                                }
                                              }).toList(),
                                              onChanged: (value) {
                                                // isLoadingSubInv = true;
                                                setState(() {
                                                  valSubInv = value;
                                                  // isLoadingSubInv = false;
                                                });
                                              },
                                            ), */
                                          Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                resultSubInv == null
                                                    ? ''
                                                    : resultSubInv.toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            /* Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Organization',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: isLoadingOrgId
                                          ? DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: thirdColor,
                                              hint: Text(
                                                'Loading ...',
                                                style: TextStyle(fontSize: 16),
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
                                              value: null,
                                              items: null,
                                              onChanged: null,
                                            )
                                          : DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: thirdColor,
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
                                              value: valOrgId,
                                              items:
                                                  dataSubInvOrgId.map((item) {
                                                if (dataSubInvOrgId.isEmpty) {
                                                  return DropdownMenuItem(
                                                    child: Text(''),
                                                    value: null,
                                                  );
                                                } else {
                                                  return DropdownMenuItem(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(item[
                                                          'ORGANIZATION_CODE']),
                                                    ),
                                                    value:
                                                        item['ORGANIZATION_ID'],
                                                  );
                                                }
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  valOrgId = value;
                                                });
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ), */
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Expired Date',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: thirdColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                resultEd == null
                                                    ? ''
                                                    : resultEd.substring(
                                                            0,
                                                            resultEd.length -
                                                                2) +
                                                        '20' +
                                                        resultEd.substring(
                                                            resultEd.length -
                                                                2),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Stock On-Hand',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: thirdColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            isLoadingStockOnHand
                                                ? Text(
                                                    'Loading ...',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    valOnHandStock != null
                                                        ? valOnHandStock
                                                            .toString()
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'UOM On-Hand',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: thirdColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            isLoadingUomOnHand
                                                ? Text(
                                                    'Loading ...',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    valOnHandUom != null
                                                        ? valOnHandUom
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manufacturer',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 14),
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
                                color: thirdColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        valKodeItem == null
                                            ? ''
                                            : valKodeItem
                                                .substring(
                                                    valKodeItem
                                                            .indexOf('|||| ') +
                                                        5,
                                                    valKodeItem
                                                        .indexOf(' |||||'))
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Future _openScanner(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => ScannerPage()));

    setState(() {
      valKodeItem = null;
      resultLotNumber = null;
      resultId = null;
      valSubInv = null;
      valOrgId = null;
      valOnHandStock = null;
      valOnHandUom = null;
      valUom = null;
      resultInvItemId = null;
      resultQuantity.text = '';
      valLocationId = null;
      resultDescSubstr = null;
      resultEd = null;
      resultSubInv = null;
      dataKodeItem = [];
      dataSubInvOrgId = [];
      dataUom = [];

      resultCode = result;
      if (resultCode != null) {}
    });
  }
}
