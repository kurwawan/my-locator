import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer_sixth.dart';
import 'package:my_locator/pages/drawer_third.dart';
import 'package:my_locator/theme.dart';

import '../drawer_fourth.dart';

class ChoicePage extends StatefulWidget {
  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 320,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_left,
                    size: 70,
                  ),
                  Text('SIMPAN DRAFT'),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DrawerThirdPage()));
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: 320,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: secondColor,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TRANSAKSI DRAFT'),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 70,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DrawerFourthPage()));
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: 320,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: thirdColor,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TRANSAKSI PRATIMBANG'),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 70,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DrawerSixthPage()));
              },
            ),
          ),
        ],
      )),
    );
  }
}
