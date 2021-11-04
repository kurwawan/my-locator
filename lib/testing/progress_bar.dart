import 'package:flutter/material.dart';

class ProgressBarTest extends StatefulWidget {
  @override
  _ProgressBarTestState createState() => _ProgressBarTestState();
}

class _ProgressBarTestState extends State<ProgressBarTest> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Bar Animation'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          width: double.maxFinite,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              /* minimumSize: Size.fromHeight(72), */
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text('Please wait ....'),
                    ],
                  )
                : Text('SAVE'),
            onPressed: () async {
              // if (isLoading) return;
              setState(() {
                isLoading = true;
              });
              await Future.delayed(Duration(seconds: 5));
              setState(() {
                isLoading = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
