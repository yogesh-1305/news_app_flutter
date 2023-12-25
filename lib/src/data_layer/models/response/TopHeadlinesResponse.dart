import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';

class TopHeadlinesResponse {
  TopHeadlinesResponse({
    this.status,
    this.totalResults,
    this.articles,
    this.exceptionType = ExceptionType.noException,
  });

  TopHeadlinesResponse.fromJson(dynamic json) {
    status = json['status'];
    totalResults = json['totalResults'];
    exceptionType = ExceptionType.noException;
    if (json['articles'] != null) {
      articles = [];
      json['articles'].forEach((v) {
        articles?.add(Articles.fromJson(v));
      });
    }
  }

  String? status;
  int? totalResults;
  List<Articles>? articles;
  ExceptionType exceptionType = ExceptionType.noException;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['totalResults'] = totalResults;
    map["exceptionType"] = exceptionType.toString();
    if (articles != null) {
      map['articles'] = articles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Articles {
  Articles({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Articles.fromJson(dynamic json) {
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Source? source;
  dynamic author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (source != null) {
      map['source'] = source?.toJson();
    }
    map['author'] = author;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['urlToImage'] = urlToImage;
    map['publishedAt'] = publishedAt;
    map['content'] = content;
    return map;
  }
}

class Source {
  Source({
    this.id,
    this.name,
  });

  Source.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  dynamic id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
