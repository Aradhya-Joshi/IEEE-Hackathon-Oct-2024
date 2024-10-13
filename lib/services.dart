import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApiService {
  final String apiKey = dotenv.env['API_BASE_URL'] ?? '';
  final String apiUrl = dotenv.env['API_KEY'] ?? '';

  // General method to fetch data from API and decode response
  Future<dynamic> _fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data from $url');
    }
  }

  // Fetch articles by query
  Future<List<Article>> fetchArticles({String query = '2024-10-13'}) async {
    List<Article> articles = [];

    final data = await _fetchData(
      '$apiUrl?q=$query&language=en&sortBy=popularity&apiKey=$apiKey',
    );

    for (final item in data['articles']) {
      final Article article = Article.fromJson(item);

      if (article.isValid()) {
        articles.add(article);
      }
    }

    return articles;
  }
}

class Article {
  final String title;
  final String description;
  final String url;
  final String? author;
  final String? sourceName;
  final String? urlToImage;
  final DateTime? publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    this.author,
    this.sourceName,
    this.urlToImage,
    this.publishedAt,
  });

  // Factory to parse JSON into Article object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      author: json['author'],
      sourceName: json['source'] != null ? json['source']['name'] : null,
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  // Check if an article is valid (i.e., has non-null critical fields)
  bool isValid() {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        url.isNotEmpty &&
        (author != null && author!.isNotEmpty) &&
        (sourceName != null && sourceName!.isNotEmpty) &&
        (urlToImage != null && urlToImage!.isNotEmpty);
  }
}
