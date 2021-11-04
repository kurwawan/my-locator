import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_locator/config.dart';
import 'package:my_locator/pages/menu/view_on_hand_empty_result.dart';
import 'package:my_locator/pages/menu/view_on_hand_result.dart';
import 'package:my_locator/theme.dart';
import 'package:http/http.dart' as http;
import 'package:my_locator/pages/model/on_hand_post.dart';

class ViewOnHandPage extends StatefulWidget {
  @override
  _ViewOnHandPageState createState() => _ViewOnHandPageState();
}

class _ViewOnHandPageState extends State<ViewOnHandPage> {
  var baseUrl = Config.url;
  bool isLoading = false,
      isLoadingInvOnHand = false,
      isLoadingSubInv = false,
      isLoadingSubmit = false,
      isButtonDisabled,
      isVisible = true,
      isConnected = false;
  StreamSubscription sub;

  TextEditingController resultSearch = new TextEditingController();

  String valOrg;
  List<dynamic> dataOrg = List();
  Future getOrg() async {
    String apiOrganization =
        "$baseUrl/my_locator/backend/web/getdata/organization";

    try {
      final response = await http.get(apiOrganization);
      var listDataOrg = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            dataOrg = listDataOrg;
          });
        }
      } else {
        throw Exception('Failed to request data');
      }
      // print("data : $listDataOrg");
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

  String valInvOnHand;
  List<dynamic> dataInvOnHand = List();
  Future getInvOnHand(String id) async {
    String apiInvOnHand =
        "$baseUrl/my_locator/backend/web/getdata/invonhand?id=" + id;

    try {
      final response = await http.get(apiInvOnHand);
      var listDataInvOnHand = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            dataInvOnHand = listDataInvOnHand;
          });
        }
      } else {
        throw Exception('Failed to request data');
      }
      // print("data : $listDataInvOnHand");
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

  String valItemOnHand;
  List<dynamic> dataItemOnHand = List();
  Future getItemOnHand(String id, String usr, String search) async {
    String apiItemOnHand =
        "$baseUrl/my_locator/backend/web/getdata/itemonhand?id=" +
            id +
            "&usr=" +
            usr +
            "&search=" +
            search;

    try {
      final response = await http.get(apiItemOnHand);
      var listDataItemOnHand = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            dataItemOnHand = listDataItemOnHand;
          });

          if (dataItemOnHand.skip(1).isNotEmpty) {
            print('DATA AVAILABLE');
          } else {
            print('KODE ITEM KOSONG');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ViewOnHandIsEmptyResultPage()));
          }
        }
      } else {
        throw Exception('Failed to request data');
      }
      // print("data : $listDataItemOnHand");
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

  Future<List<OnHandPost>> futureOnHandPost;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none &&
            result != ConnectivityResult.mobile);
        if (isConnected) {
          isButtonDisabled = false;
          isLoading = true;
          getOrg().whenComplete(() {
            isLoading = false;
          }).catchError((e) {
            print(e);
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
    return Scaffold(
      body: isConnected
          ? isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Report Stock On Hand',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Organization :',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: isLoadingInvOnHand
                                                ? DropdownButton(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Loading ...',
                                                      style: TextStyle(
                                                          fontSize: 16),
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
                                                      fontSize: 14,
                                                    ),
                                                    value: null,
                                                    items: null,
                                                    onChanged: null,
                                                  )
                                                : DropdownButton(
                                                    isExpanded: true,
                                                    hint: Text('Pilih Item'),
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
                                                    value: valOrg,
                                                    items: dataOrg.map((item) {
                                                      if (dataOrg.isEmpty) {
                                                        return DropdownMenuItem(
                                                          child: Text(''),
                                                          value: null,
                                                        );
                                                      } else {
                                                        return DropdownMenuItem(
                                                          child: Text(item[
                                                                  'ORGANIZATION_CODE'] /*  +
                                                              " | " +
                                                              item[
                                                                  'ORGANIZATION_ID'] */
                                                              ),
                                                          value: item[
                                                              'ORGANIZATION_ID'],
                                                        );
                                                      }
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      isLoadingInvOnHand = true;
                                                      setState(() {
                                                        valOrg = value;
                                                        // print(valOrg);

                                                        dataInvOnHand = [];
                                                        dataItemOnHand = [];
                                                        getInvOnHand(valOrg)
                                                            .whenComplete(() {
                                                          isLoadingInvOnHand =
                                                              false;
                                                          valInvOnHand = null;
                                                          valItemOnHand = null;
                                                          resultSearch.text =
                                                              '';
                                                          isVisible = false;
                                                        }).catchError((e) {
                                                          print(e);
                                                        });

                                                        /* futureOnHandPost =
                                                        OnHandPost.connectToApi(
                                                            '', '', '');
                                                    print('futureonhand null'); */
                                                      });
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Sub Inventory :',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: isLoadingSubInv
                                                ? DropdownButton(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Loading ...',
                                                      style: TextStyle(
                                                          fontSize: 16),
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
                                                      fontSize: 14,
                                                    ),
                                                    value: null,
                                                    items: null,
                                                    onChanged: null,
                                                  )
                                                : DropdownButton(
                                                    isExpanded: true,
                                                    hint: Text('Pilih Item'),
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
                                                    value: valInvOnHand,
                                                    items: dataInvOnHand
                                                        .map((item) {
                                                      if (dataOrg.isEmpty) {
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
                                                      isLoadingSubInv = true;
                                                      setState(() {
                                                        valInvOnHand = value;

                                                        /* getItemOnHand(
                                                                valInvOnHand,
                                                                valOrg)
                                                            .whenComplete(() {
                                                          isLoadingSubInv =
                                                              false;
                                                          valItemOnHand = null;
                                                          isVisible = false;
                                                        }).catchError((e) {
                                                          print(e);
                                                        }); */
                                                        isLoadingSubInv = false;
                                                        resultSearch.text = '';
                                                        valItemOnHand = null;
                                                        dataItemOnHand = [];
                                                      });
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Text(
                          'Cari Item :',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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
                                        isLoading = true;
                                      });
                                      getItemOnHand(valInvOnHand, valOrg,
                                              resultSearch.text.toString())
                                          .whenComplete(() {
                                        valItemOnHand = null;
                                        isLoading = false;
                                      }).catchError((e) {
                                        print(e);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Item :',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text('Pilih Item'),
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
                                          value: valItemOnHand,
                                          items: dataItemOnHand
                                              .map((item) {
                                                if (dataItemOnHand.isEmpty) {
                                                  return DropdownMenuItem(
                                                    child: Text(''),
                                                    value: null,
                                                  );
                                                } else {
                                                  return DropdownMenuItem(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5.0,
                                                        bottom: 5.0,
                                                      ),
                                                      child: Text((item[
                                                                  'VIEW_ITEM'] ==
                                                              " ")
                                                          ? "- - - - - - - - -"
                                                          : item['VIEW_ITEM']),
                                                    ),
                                                    value: item['VIEW_ITEM'] ==
                                                            " "
                                                        ? "- - - - - - - - -"
                                                        : item['VIEW_ITEM'],
                                                  );
                                                }
                                                /*  return DropdownMenuItem(
                                            child: Text(
                                                (item['VIEW_ITEM'] == " ")
                                                    ? "- - - - - - - - -"
                                                    : item['VIEW_ITEM']),
                                            value: item['VIEW_ITEM'],
                                          ); */
                                              })
                                              .skip(1)
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              if (valItemOnHand == ' ') {
                                                valItemOnHand = ' ';
                                                isVisible = false;
                                              } else {
                                                valItemOnHand = value;
                                                isVisible = false;
                                              }
                                              print(valItemOnHand);
                                            });
                                          },
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
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Kode Item :',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: thirdColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          (valItemOnHand != null)
                                              ? valItemOnHand.substring(0,
                                                  valItemOnHand.indexOf(' |'))
                                              : (valItemOnHand == "-")
                                                  ? ""
                                                  : "",
                                          style: TextStyle(
                                            fontSize: 18,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi Item :',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: thirdColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        (valItemOnHand != null)
                                            ? valItemOnHand.substring(
                                                valItemOnHand.indexOf('|') + 2,
                                                valItemOnHand.length)
                                            : (valItemOnHand == "-")
                                                ? ""
                                                : "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
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
                            child:
                                /* isLoadingSubmit
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
                                      Text('Request Report ...'),
                                    ],
                                  )
                                :  */
                                Text('SUBMIT'),
                            onPressed:
                                /* isButtonDisabled
                                ? null
                                :  */
                                () /* async */ {
                              if (valOrg == null ||
                                  valItemOnHand == null ||
                                  valInvOnHand == null) {
                                Fluttertoast.showToast(
                                    msg: "Tidak boleh ada yang kosong",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 15,
                                    backgroundColor: fourthColor,
                                    textColor: primaryColor,
                                    fontSize: 14.0);
                              } else {
                                if (valOrg == null ||
                                    valItemOnHand == null ||
                                    valInvOnHand == null) {
                                  print("body kosong");
                                } else if (valOrg == '' ||
                                    valItemOnHand == '' ||
                                    valInvOnHand == '') {
                                  print("body kosong");
                                } else {
                                  /* futureOnHandPost = OnHandPost.connectToApi(
                                      valInvOnHand,
                                      valItemOnHand.substring(
                                          0, valItemOnHand.indexOf(' |')),
                                      valOrg);
                                  print(valInvOnHand +
                                      " | " +
                                      valItemOnHand.substring(
                                          0, valItemOnHand.indexOf(' |')) +
                                      " | " +
                                      valOrg);

                                  futureOnHandPost.whenComplete(() {
                                    setState(() {
                                      isLoadingSubmit = false;
                                      isButtonDisabled = false;
                                      isVisible = true;
                                    });
                                  }).catchError((e) {
                                    print(e);
                                  }); */
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewOnHandResultPage(
                                                resultInvOnHand: valInvOnHand,
                                                resultItemOnHand:
                                                    valItemOnHand.substring(
                                                        0,
                                                        valItemOnHand
                                                            .indexOf(' |')),
                                                resultOrgId: valOrg,
                                              )));
                                }

                                /* setState(() {
                                  isLoadingSubmit = true;
                                  isButtonDisabled = true;
                                  isVisible = false;
                                }); */
                              }
                            },
                          ),
                        ),
                        /* Divider(
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: secondColor,
                          thickness: 3,
                        ),
                        Visibility(
                          visible: isVisible,
                          child: Expanded(
                            child: Container(
                              child: FutureBuilder(
                                future: futureOnHandPost,
                                builder: (context, snapshot) {
                                  // if (snapshot.hasData) {
                                  List<OnHandPost> report = snapshot.data;
                                  if (snapshot.hasData) {
                                    // print(report.toString());
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: report.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                report[index].rownum,
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Nomor Lot',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].lotNumber ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .lotNumber,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Locator',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].locator ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .locator,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Quantity',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].transQty ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .transQty,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'UOM',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].uom ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .uom,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Expired Date',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].ed ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .ed,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Status',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].status ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .status,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Manufacturer',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].manufacture ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .manufacture,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Supplier',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                    border: Border
                                                                        .all(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 2,
                                                                    ),
                                                                    color:
                                                                        thirdColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                    ),
                                                                    child: Text(
                                                                      report[index].supplier ==
                                                                              null
                                                                          ? '-'
                                                                          : report[index]
                                                                              .supplier,
                                                                      style:
                                                                          TextStyle(
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
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Divider(
                                                  thickness: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    // print(report.toString());
                                    return Text("");
                                  }
                                },
                              ),
                            ),
                          ),
                        ), */
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
}
