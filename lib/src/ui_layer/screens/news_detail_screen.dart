import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key, required this.article});

  final Articles article;

  @override
  Widget build(BuildContext context) {
    return Text('NewsDetailScreen');
  }
}
