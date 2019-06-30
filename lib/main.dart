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
            return Row(
              children: <Widget>[
                Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg/440px-An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg",
                    width: 120,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('標題'),
                      Text('說明'),
                      Text('時間'),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            );
          },
        ),
      ),
    );
  }
}
