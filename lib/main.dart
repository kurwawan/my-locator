import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer.dart';
import 'package:my_locator/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var message = sharedPreferences.getString('message');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: message == null ? Login() : DrawerPage(),
  ));
}
