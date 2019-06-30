import 'package:flutter/material.dart';

void main() => runApp(StoreListPage());

class StoreListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taipei Zoo",
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("台北市立動物園"),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Text("item ${index}");
          },
        ),
      ),
    );
  }
}
