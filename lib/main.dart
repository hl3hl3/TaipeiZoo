import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(StoreListPage());

class StoreListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _fetchData();
    return MaterialApp(
      title: "Taipei Zoo",
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("台北市立動物園"),
        ),
        body: _getStoreList(),
      ),
    );
  }

  _fetchData() async {
    var url = 'https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  ListView _getStoreList() {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 2,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        var storeImageUrl =
            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg/440px-An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg";
        var storeImage = Image.network(
          storeImageUrl,
          width: 120,
        );
        var storeTitle = '標題最多1行過長變點點點標題最多1行過長變點點點';
        var storeInfo = '說明最多2行過長變點點點說明最多2行過長變點點點說明最多2行過長變點點點';
        var storeMemo = '時間最多1行過長變點點點時間最多1行過長變點點點';
        return Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: storeImage,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    storeTitle,
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    storeInfo,
                    style: TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    storeMemo,
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
    );
  }
}
