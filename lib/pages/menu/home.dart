import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer_fifth.dart';
import 'package:my_locator/pages/drawer_second.dart';
import 'package:my_locator/pages/drawer_sixth.dart';
import 'package:my_locator/pages/drawer_third.dart';
import 'package:my_locator/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_locator/pages/drawer_fourth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrResult = 'Not yet scanned';
  String message = '';

  Future getMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      message = sharedPreferences.getString('message');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 205 / 206,
        children: [
          /* Container(
            margin: EdgeInsets.all(10),
            color: primaryColor,
            child: Center(
              child: Text(
                "1",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ), */
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerSecondPage()),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.view_comfy,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'Stock On Hand',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerFifthPage()),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'Stock Scanner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerThirdPage()),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'From\nLocator',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerFourthPage()),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'To\nLocator',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerSixthPage()),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.line_weight,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'To Locator Pratimbang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
