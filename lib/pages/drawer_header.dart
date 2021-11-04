import 'package:flutter/material.dart';
import 'package:my_locator/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
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
    return Container(
      color: primaryColor,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                )),
          ),
          Text(
            message,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18,
              fontWeight: FontWeight.bold),
          ),
          Text(
            'PT. IFARS Pharceutical Laboraties',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
