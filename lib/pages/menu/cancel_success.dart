import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer.dart';
import 'package:my_locator/pages/drawer_fourth.dart';
import 'package:my_locator/pages/drawer_sixth.dart';

import '../../theme.dart';

class CancelSuccess extends StatefulWidget {
  // const CancelSuccess({Key? key}) : super(key: key);
  final String data;
  CancelSuccess({Key key, this.data}) : super(key: key);
  @override
  _CancelSuccessState createState() => _CancelSuccessState();
}

class _CancelSuccessState extends State<CancelSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("data widget.data : " + widget.data);
    if (widget.data == "PRATIMBANG") {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerSixthPage()));
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerFourthPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive_rounded,
                  size: 150,
                  color: fifthColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Cancel Data Berhasil',
                  style: TextStyle(
                    fontSize: 24,
                    color: fifthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(fifthColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
