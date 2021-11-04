import 'package:flutter/material.dart';
import 'package:my_locator/pages/drawer_second.dart';
import 'package:my_locator/theme.dart';

class ViewOnHandIsEmptyResultPage extends StatefulWidget {
  // const ViewOnHandIsEmptyResultPage({Key? key}) : super(key: key);

  @override
  _ViewOnHandIsEmptyResultPageState createState() =>
      _ViewOnHandIsEmptyResultPageState();
}

class _ViewOnHandIsEmptyResultPageState
    extends State<ViewOnHandIsEmptyResultPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DrawerSecondPage()));
        return true;
      },
      child: Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.not_listed_location_sharp,
                  size: 150,
                  color: fifthColor,
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  'Data tidak di temukan !',
                  style: TextStyle(
                    fontSize: 24,
                    color: fifthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: fifthColor,
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      /* minimumSize: Size.fromHeight(72), */
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                    child: Text('KEMBALI'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerSecondPage()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
