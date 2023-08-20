import 'dart:convert';

class SourcesRes {
  String? status;
  List<SourceData>? sources;

  SourcesRes({
    this.status,
    this.sources,
  });

  factory SourcesRes.fromJson(String str) =>
      SourcesRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SourcesRes.fromMap(Map<String, dynamic> json) => SourcesRes(
        status: json["status"],
        sources: json["sources"] == null
            ? []
            : List<SourceData>.from(
                json["sources"]!.map((x) => SourceData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "sources": sources == null
            ? []
            : List<dynamic>.from(sources!.map((x) => x.toMap())),
      };
}

class SourceData {
  String? id;
  String? name;
  String? description;
  String? url;
  String? category;
  String? language;
  String? country;

  SourceData({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  factory SourceData.fromJson(String str) =>
      SourceData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SourceData.fromMap(Map<String, dynamic> json) => SourceData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: json["category"],
        language: json["language"],
        country: json["country"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "category": categoryValues.reverse[category],
        "language": languageValues.reverse[language],
        "country": countryValues.reverse[country],
      };
}

enum Category {
  BUSINESS,
  ENTERTAINMENT,
  GENERAL,
  HEALTH,
  SCIENCE,
  SPORTS,
  TECHNOLOGY
}

final categoryValues = EnumValues({
  "business": Category.BUSINESS,
  "entertainment": Category.ENTERTAINMENT,
  "general": Category.GENERAL,
  "health": Category.HEALTH,
  "science": Category.SCIENCE,
  "sports": Category.SPORTS,
  "technology": Category.TECHNOLOGY
});

enum Country { US }

final countryValues = EnumValues({"us": Country.US});

enum Language { EN, ES }

final languageValues = EnumValues({"en": Language.EN, "es": Language.ES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
