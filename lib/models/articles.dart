import 'dart:convert';

class ArticleRes {
  String? status;
  int? totalResults;
  List<ArticleData>? articles;

  ArticleRes({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory ArticleRes.fromJson(String str) =>
      ArticleRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleRes.fromMap(Map<String, dynamic> json) => ArticleRes(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: json["articles"] == null
            ? []
            : List<ArticleData>.from(
                json["articles"].map((x) => ArticleData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles == null
            ? []
            : List<dynamic>.from(articles!.map((x) => x.toMap())),
      };
}

class ArticleData {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  ArticleData({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory ArticleData.fromJson(String str) =>
      ArticleData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleData.fromMap(Map<String, dynamic> json) => ArticleData(
        source: json["source"] == null ? null : Source.fromMap(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "source": source?.toMap(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content,
      };
}

class Source {
  String? id;
  String? name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromJson(String str) => Source.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
