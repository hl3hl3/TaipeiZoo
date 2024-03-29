import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:taipei_zoo_20190630/hero_image.dart';
import 'package:taipei_zoo_20190630/store_detail_page.dart';
import 'package:taipei_zoo_20190630/store_list_data.dart';

void main() => runApp(StoreListPage());

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

const int PAGE_EMPTY = 0;
const int PAGE_LOADING = 1;
const int PAGE_OK = 2;
const int PAGE_ERROR = 3;

class _StoreListPageState extends State<StoreListPage> {
  StoreListResponse _responseData;
  int _pageState = PAGE_EMPTY;
  bool _showGrid = false;

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
          actions: <Widget>[
            IconButton(
              icon: _showGrid ? Icon(Icons.list) : Icon(Icons.grid_on),
              onPressed: () {
                setState(() {
                  _showGrid = !_showGrid;
                });
              },
            )
          ],
        ),
        body: _getPageBody(),
      ),
    );
  }

  Widget _getPageBody() {
    switch (_pageState) {
      case PAGE_EMPTY:
        return getEmptyContent();
      case PAGE_LOADING:
        return getLoadingContent();
      case PAGE_OK:
        return _showGrid ? _getStoreGrid() : _getStoreList();
      case PAGE_ERROR:
      default:
        return getErrorContent();
    }
  }

  _fetchData() async {
    setState(() {
      _pageState = PAGE_LOADING;
    });
    var url =
        'https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        String resultUtf8 = Utf8Decoder().convert(response.bodyBytes);
        print('Response body resultUtf8: ${resultUtf8}');
        Map<String, dynamic> jsonMap = jsonDecode(resultUtf8);
        setState(() {
          _responseData = StoreListResponse.fromJson(jsonMap);
          _pageState = PAGE_OK;
        });
      } on FormatException catch (e) {
        setErrorState();
      }
    } else {
      setErrorState();
    }
  }

  void setErrorState() {
    setState(() {
      _pageState = PAGE_ERROR;
    });
  }

  GridView _getStoreGrid() {
    return GridView.builder(
      itemCount: _responseData == null ? 0 : _responseData.result.count,
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            _showDetailPage(context, _responseData.result.results[index]);
          },
          child: _getStoreGridItem(index),
        );
      },
    );
  }

  Card _getStoreGridItem(int index) {
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
      storeImage = HeroImage(
          storeImageUrl,
          Image.network(
            storeImageUrl,
            fit: BoxFit.cover,
          ));
    } else {
      storeImage = CircularProgressIndicator();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.5,
            child: storeImage,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
        ],
      ),
    );
  }

  _showDetailPage(BuildContext context, StoreListItem itemData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return StoreDetailPage(itemData);
      },
    ));
  }

  ListView _getStoreList() {
    return ListView.separated(
      itemCount: _responseData == null ? 0 : _responseData.result.count,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 2,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              _showDetailPage(context, _responseData.result.results[index]);
            },
            child: _getStoreListItem(context, index));
      },
    );
  }

  Widget _getStoreListItem(BuildContext context, int index) {
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
      storeImage = HeroImage(
          storeImageUrl,
          Image.network(
            storeImageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ));
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
  }

  Widget getEmptyContent() {
    return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "╮(╯∀╰)╭",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "沒有資料",
              style: Theme.of(context).textTheme.title,
            ),
          ],
        ));
  }

  Widget getErrorContent() {
    return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "╮(╯_╰)╭",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "發生錯誤\n請稍後再試",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ],
        ));
  }

  Widget getLoadingContent() {
    Widget item = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: <Widget>[
          Container(
            color: Colors.white,
            width: 80,
            height: 80,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    width: 100,
                    height: 12,
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    width: 300,
                    height: 12,
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    width: 300,
                    height: 12,
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    width: 140,
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ]));

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white70,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          item,
          item,
          item,
          item,
          item,
        ],
      ),
    );
  }
}
