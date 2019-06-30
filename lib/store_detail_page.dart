import 'package:flutter/material.dart';
import 'package:taipei_zoo_20190630/hero_image.dart';
import 'package:taipei_zoo_20190630/store_list_data.dart';

class StoreDetailPage extends StatelessWidget {
  StoreListItem pageData;

  StoreDetailPage(this.pageData);

  @override
  Widget build(BuildContext context) {
    String memo = pageData.eMemo == null || pageData.eMemo == ""
        ? "無休館資訊"
        : pageData.eMemo;
    String category = pageData.eCategory;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(pageData.eName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            HeroImage(pageData.ePicURL, Image.network(pageData.ePicURL)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(pageData.eInfo),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Text("${memo}\n${category}"),
                )),
                FlatButton(
                  textColor: Colors.blue,
                  splashColor: Colors.grey.shade200,
                  child: Text(
                    "在網頁開啟",
                  ),
                  onPressed: () {
                    // TODO
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
