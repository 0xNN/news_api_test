import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_api_test/models/articles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNews extends StatefulWidget {
  static const String routeName = '/bayar';
  final ArticleData articleData;
  const DetailNews({
    Key? key,
    required this.articleData,
  }) : super(key: key);

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.articleData.title!),
        elevation: 0,
      ),
      body: WebView(
        initialUrl: widget.articleData.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
