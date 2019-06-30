import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taipei_zoo_20190630/store_list_data.dart';

void main() => runApp(StoreListPage());

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  StoreListResponse _responseData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
    var url =
        'https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    var resultUtf8 = Utf8Decoder().convert(response.bodyBytes);
    print('Response body resultUtf8: ${resultUtf8}');
    Map<String, dynamic> jsonMap = jsonDecode(resultUtf8);
    setState(() {
      _responseData = StoreListResponse.fromJson(jsonMap);
    });
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
        var storeImageUrl;
        var storeTitle = '';
        var storeInfo = '';
        var storeMemo = '';
        if (_responseData != null) {
          StoreListItem itemData = _responseData.result.results[index];
          storeImageUrl = itemData.ePicURL;
          storeTitle = itemData.eName;
          storeInfo = itemData.eInfo;
          storeMemo = itemData.eMemo == null || itemData.eMemo == ''
              ? "無休館資訊"
              : itemData.eMemo;
        }
        Widget storeImage;
        if (storeImageUrl != null && storeImageUrl.startsWith("http")) {
          storeImage = Image.network(
            storeImageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          );
        } else {
          storeImage = CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              storeImage,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
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
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
    );
  }
}
