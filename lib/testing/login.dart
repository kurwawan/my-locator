import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer.dart';
import 'package:my_locator/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      signIn(usernameController.text, passwordController.text);
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'MY LOCATOR',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 25,
            fontWeight: FontWeight.bold,
            color: fourthColor,
          ),
        )
      ],
    );
  }

  Future signIn(String username, String password) async {
    Map data = {'username': username, 'password': password};
    var jsonData = null;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var response = await http.post(
        "http://192.168.140.99/my_locator/backend/web/auth/login",
        body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      String name = jsonData['data']['last_name'];
      String pesan = jsonData['data']['status'];

      if (pesan == "true") {
        setState(() {
          sharedPreferences.setString("message", name.toString());
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 14.0);
          print(response.body);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DrawerPage()));
        });
      } else {
        Fluttertoast.showToast(
            msg: "Username dan Password tidak sesuai !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        print(response.body);
      }
    } else {
      print("connection failed");
    }
  }

  Widget _buildUsernameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        validator: (e) {
          if (e.isEmpty) {
            return "Please insert username";
          }
        },
        onSaved: (e) => usernameController,
        controller: usernameController,
        decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: TextStyle(
            fontSize: 16,
            color: primaryColor,
            decorationColor: primaryColor,
          ),
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.person,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontSize: 16,
            color: primaryColor,
            decorationColor: primaryColor,
          ),
          prefixIcon: Icon(
            Icons.vpn_key,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              check();
            },
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      )
                    ],
                  ),
                  _buildUsernameRow(),
                  _buildPasswordRow(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: fourthColor,
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70),
                    )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                SizedBox(
                  height: 10,
                ),
                _buildContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
