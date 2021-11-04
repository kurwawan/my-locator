import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LazyLoadingTest extends StatefulWidget {
  @override
  _LazyLoadingTestState createState() => _LazyLoadingTestState();
}

class _LazyLoadingTestState extends State<LazyLoadingTest> {
  List myList;
  ScrollController scrollController = new ScrollController();
  int currentMax = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myList = List.generate(10, (i) => "Item: ${i + 1}");

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
  }

  getMoreData() {
    print('get more data ..');
    for (int i = currentMax; i < currentMax + 10; i++) {
      myList.add("Items: ${i + 1}");
    }
    currentMax = currentMax + 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazy Loading'),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: myList.length + 1,
        itemBuilder: (context, i) {
          if (i == myList.length) {
            return CupertinoActivityIndicator();
          }
          return ListTile(
            title: Text(myList[i]),
          );
        },
        itemExtent: 100,
      ),
    );
  }
}
