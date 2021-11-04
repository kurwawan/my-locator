import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer_fourth.dart';
import 'package:my_locator/pages/drawer_sixth.dart';
import 'package:my_locator/theme.dart';

class TrasanctionSuccessPage extends StatefulWidget {
  final String data;
  TrasanctionSuccessPage({Key key, this.data}) : super(key: key);
  @override
  _TrasanctionSuccessPageState createState() => _TrasanctionSuccessPageState();
}

class _TrasanctionSuccessPageState extends State<TrasanctionSuccessPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == "PRATIMBANG") {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerSixthPage()));
        /* Navigator.pop(context); */
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerFourthPage()));
        /* Navigator.pop(context); */
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
                  Icons.check_circle,
                  size: 150,
                  color: primaryColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Transaksi Data Berhasil',
                  style: TextStyle(
                    fontSize: 24,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
