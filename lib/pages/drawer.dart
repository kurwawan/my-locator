import 'package:flutter/material.dart';
import 'package:my_locator/pages/login.dart';
import 'package:my_locator/pages/menu/from_locator.dart';
import 'package:my_locator/pages/menu/to_locator_pratimbang.dart';
import 'package:my_locator/pages/menu/to_locator_second.dart';
import 'package:my_locator/pages/menu/view_on_hand.dart';
import 'package:my_locator/pages/menu/view_on_hand_scan.dart';
import 'package:my_locator/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_header.dart';
import 'menu/home.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String message = "";

  Future getMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      message = sharedPreferences.getString('message');
    });
  }

  Future logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove('message');
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  var currentPage = DrawerSections.home;
  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.home) {
      container = HomePage();
    } else if (currentPage == DrawerSections.viewOnHand) {
      container = ViewOnHandPage();
    } else if (currentPage == DrawerSections.fromLocator) {
      container = FromLocatorPage();
    } else if (currentPage == DrawerSections.toLocator) {
      container = ToLocatorSecondPage();
    } else if (currentPage == DrawerSections.viewOnHandScan) {
      container = ViewOnHandScanPage();
    } else if (currentPage == DrawerSections.toLocatorBbn) {
      container = ToLocatorPratimbangPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Locator',
        ),
        backgroundColor: primaryColor,
      ),
      body: container,
      drawer: Container(
        width: 270,
        child: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          /* menuItem(1, "Home", Icons.dashboard,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "View On Hand", Icons.visibility,
              currentPage == DrawerSections.viewOnHand ? true : false),
          menuItem(3, "From Locator", Icons.turned_in_not,
              currentPage == DrawerSections.fromLocator ? true : false),
          menuItem(4, "To Locator", Icons.turned_in,
              currentPage == DrawerSections.toLocator ? true : false),
          Divider(), */
          InkWell(
            onTap: () {
              logOut();
            },
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.keyboard_return,
                      size: 20,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.viewOnHand;
            } else if (id == 3) {
              currentPage = DrawerSections.fromLocator;
            } else if (id == 4) {
              currentPage = DrawerSections.toLocator;
            } else if (id == 5) {
              currentPage = DrawerSections.viewOnHandScan;
            } else if (id == 6) {
              currentPage = DrawerSections.toLocatorBbn;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  viewOnHand,
  fromLocator,
  toLocator,
  viewOnHandScan,
  toLocatorBbn,
}
