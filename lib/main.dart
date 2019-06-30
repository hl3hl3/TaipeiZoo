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
        body: ListView.separated(
          itemCount: 10,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 2,);
          },
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg/440px-An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg",
                    width: 120,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '標題最多1行過長變點點點標題最多1行過長變點點點',
                        style: TextStyle(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '說明最多2行過長變點點點說明最多2行過長變點點點說明最多2行過長變點點點',
                        style: TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '時間最多1行過長變點點點時間最多1行過長變點點點',
                        style: TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
