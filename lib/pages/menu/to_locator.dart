import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_locator/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/pages/menu/to_locator_transfer.dart';
import '../../theme.dart';

class ToLocatorPage extends StatefulWidget {
  @override
  _ToLocatorPageState createState() => _ToLocatorPageState();
}

class _ToLocatorPageState extends State<ToLocatorPage> {
  var id = [],
      itemCode = [],
      desc = [],
      transactionUom = [],
      locatorId = [],
      locatorDes = [],
      subInvCode = [],
      invItemId = [],
      transactionQty = [],
      organizationId = [],
      lotNumber =
          [] /* ,
      transferSubInv = [],
      transferLocator = [],
      transferQty = [] */
      ;
  bool isLoading = true, isConnected = false;
  ScrollController scrollController = ScrollController();
  int currentMax = 10;

  Future getListDraft() async {
    var baseUrl = Config.url;

    this.id = [];
    this.itemCode = [];
    this.desc = [];
    this.transactionUom = [];
    this.locatorId = [];
    this.locatorDes = [];
    this.subInvCode = [];
    this.invItemId = [];
    this.transactionQty = [];
    this.organizationId = [];
    this.lotNumber = [];
    String apiUrl = "$baseUrl/my_locator/backend/web/getdata/listlocator";

    try {
      final apiResult = await http.get(apiUrl);
      if (apiResult.statusCode == 200) {
        List data = json.decode(apiResult.body);
        if (this.mounted) {
          setState(() {
            for (var i = 0; i < data.length /* 10 */; i++) {
              this.id.add(data[i]['ID']);
              this.itemCode.add(data[i]['ITEM_CODE']);
              this.desc.add(data[i]['DESCRIPTION']);
              this.transactionUom.add(data[i]['TRANSACTION_UOM']);
              this.locatorId.add(data[i]['LOCATOR_ID']);
              this.locatorDes.add(data[i]['LOCATOR_DES']);
              this.subInvCode.add(data[i]['SUBINVENTORY_CODE']);
              this.invItemId.add(data[i]['INVENTORY_ITEM_ID']);
              this.transactionQty.add(data[i]['TRANSACTION_QUANTITY']);
              this.organizationId.add(data[i]['ORGANIZATION_ID']);
              this.lotNumber.add(data[i]['LOT_NUMBER']);
              /* if (i % 4 == 0) { */
              /* scrollController.addListener(() {
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            if (i % 10 == 0) {
              print('get more data..');
              return;
            }
          }
        }); */
              // }
            }

            /* scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          for (int i = currentMax; i < data.length; i++) {
            this.id.add(data[i]['ID']);
            this.itemCode.add(data[i]['ITEM_CODE']);
            this.desc.add(data[i]['DESCRIPTION']);
            this.transactionUom.add(data[i]['TRANSACTION_UOM']);
            this.locatorId.add(data[i]['LOCATOR_ID']);
            this.locatorDes.add(data[i]['LOCATOR_DES']);
            this.subInvCode.add(data[i]['SUBINVENTORY_CODE']);
            this.invItemId.add(data[i]['INVENTORY_ITEM_ID']);
            this.transactionQty.add(data[i]['TRANSACTION_QUANTITY']);
            this.organizationId.add(data[i]['ORGANIZATION_ID']);
            this.lotNumber.add(data[i]['LOT_NUMBER']);
            
          }

          setState(() {
            print('ssssss');
          });

          scrollController.dispose();
        }
      }); */
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
            fontSize: 14.0);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
        if (isConnected) {
          print(isConnected.toString());
        }
      });
    }, onDone: () {
      print('Task Done');
    }, onError: (error) {
      print('error task');
    }); */

    getListDraft().whenComplete(() {
      isLoading = false;
      print('done');
    }).catchError((e) {
      print(e);
      Center(
        child: Text('Gagal loading ...'),
      );
    });
  }

  /* @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : RefreshIndicator(
              color: primaryColor,
              onRefresh: getListDraft,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: id.length,
                itemBuilder: (context, index) {
                  /* if (index == id.length) {
                    } */
                  if (id.isEmpty) {
                    // return Text('Kosong');
                    return CupertinoActivityIndicator();
                  } else {
                    return ListTile(
                      onTap: () {
                        /* print(id[index]);
                  print(itemCode[index]);
                  print(desc[index]);
                  print(lotNumber[index]);
                  print(organizationId[index]);
                  print(locatorId[index]);
                  print(subInvCode[index]);
                  print(transactionQty[index]);
                  print(transactionUom[index]); */
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ToLocatorTransferPage(
                                    id: id[index].toString(),
                                    kodeItem: itemCode[index].toString(),
                                    description: desc[index].toString(),
                                    lotNumber: lotNumber[index].toString(),
                                    organizationId:
                                        organizationId[index].toString(),
                                    idLocator: locatorId[index].toString(),
                                    fromSubInv: subInvCode[index].toString(),
                                    qty: transactionQty[index].toString(),
                                    uom: transactionUom[index].toString(),
                                  )),
                        );
                      },
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Wrap(
                            direction: Axis.vertical,
                            /* spacing: 8.0,
                      runSpacing: 4.0, */
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Lot Number',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Locator',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Quantity',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          desc[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          lotNumber[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          locatorDes[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          transactionQty[index].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
    ));
  }
}
