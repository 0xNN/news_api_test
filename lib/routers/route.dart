import 'package:flutter/material.dart';
import 'package:news_api_test/models/articles.dart';
import 'package:news_api_test/pages/detail.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DetailNews.routeName:
      return MaterialPageRoute(
        builder: (context) => DetailNews(
          articleData: settings.arguments as ArticleData,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
