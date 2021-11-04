import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer_second.dart';
import 'package:my_locator/pages/model/on_hand_post.dart';
import 'package:my_locator/theme.dart';

class ViewOnHandResultPage extends StatefulWidget {
  final String resultInvOnHand, resultItemOnHand, resultOrgId;

  ViewOnHandResultPage(
      {Key key, this.resultInvOnHand, this.resultItemOnHand, this.resultOrgId})
      : super(key: key);

  @override
  _ViewOnHandResultPageState createState() => _ViewOnHandResultPageState();
}

class _ViewOnHandResultPageState extends State<ViewOnHandResultPage> {
  bool isLoading = false;

  Future<List<OnHandPost>> futureOnHandPost;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    setState(() {
      futureOnHandPost = OnHandPost.connectToApi(
              widget.resultInvOnHand.toString(),
              widget.resultItemOnHand.toString(),
              widget.resultOrgId.toString())
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /* var nav = await  */ Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerSecondPage()));
        /* if (nav == true || nav == null) {
          //change the state
        } */
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Report Stock'),
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Loading ...',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: FutureBuilder(
                    future: futureOnHandPost,
                    builder: (context, snapshot) {
                      List<OnHandPost> report = snapshot.data;
                      if (snapshot.hasData) {
                        return ListView.builder(
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: report.length,
                          itemBuilder: (BuildContext context, int index) {
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Nomor Lot',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .lotNumber ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .lotNumber,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Locator',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .locator ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .locator,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Quantity',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .transQty ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .transQty,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'UOM',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
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
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Expired Date',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
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
                                                                      .ed
                                                                      .substring(
                                                                          0,
                                                                          report[index].ed.length -
                                                                              2) +
                                                                  '20' +
                                                                  report[index]
                                                                      .ed
                                                                      .substring(
                                                                          report[index].ed.length -
                                                                              2),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Status',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .status ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .status,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Manufacturer',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .manufacture ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .manufacture,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                      ), /* 
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Supplier',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 2,
                                                        ),
                                                        color: thirdColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Text(
                                                          report[index]
                                                                      .supplier ==
                                                                  null
                                                              ? '-'
                                                              : report[index]
                                                                  .supplier,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                      ), */
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
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
                        return Text('');
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
