import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_api_test/models/articles.dart';
import 'package:news_api_test/models/sources.dart';
import 'package:news_api_test/resource/string.dart';

class ApiService {
  String endPointUrl = baseurl + "top-headlines?country=us&apiKey=" + apikey;

  Future<ArticleRes> getArticle({String? source}) async {
    if (source != null) {
      endPointUrl =
          baseurl + "top-headlines?sources=" + source + "&apiKey=" + apikey;
    }
    print("URL : " + endPointUrl);
    Response res = await get(Uri.parse(endPointUrl));
    if (res.statusCode == 200) {
      print(res.body);
      return ArticleRes.fromJson(res.body);
    } else {
      throw ("Can't get the Articles");
    }
  }

  Future<SourcesRes> getSource(String category) async {
    String url = baseurl + "sources?apiKey=" + apikey;
    if (category != "All Categories") {
      url = url + "&category=" + category;
    }
    print("URL : " + url);
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      print(res.body);
      return SourcesRes.fromJson(res.body);
    } else {
      throw ("Can't get the Sources");
    }
  }
}
