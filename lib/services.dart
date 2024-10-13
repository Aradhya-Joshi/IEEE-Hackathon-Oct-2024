import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApiService {
  final String apiKey = 'c147e1e0d10b428f8d6c62a2c4c765b8';
  final String apiUrl = 'https://newsapi.org/v2/everything';

  // General method to fetch data from API and decode response
  Future<dynamic> _fetchData(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data from $url');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fetch articles by query
  Future<List<Article>> fetchArticles({String query = '2024-10-14'}) async {
    List<Article> articles = [];

    final data = await _fetchData(
      '$apiUrl?q=$query&language=en&sortBy=popularity',
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
