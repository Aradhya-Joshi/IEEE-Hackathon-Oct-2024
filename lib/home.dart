import 'package:flutter/material.dart';
import 'package:ieee_hackahon/news_card.dart';
import 'package:ieee_hackahon/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NewsApiService newsApiService = NewsApiService();

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Home';
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = fetchData();
  }

  Future<List<Article>> fetchData({String query = ''}) async {
    return await newsApiService.fetchArticles(
        query: query.isEmpty ? _selectedFilter : query);
  }

  static const List<String> quickFilters = [
    'Home',
    'Trending',
    'India',
    'World',
    'Local',
    'Business',
    'Technology',
    'Entertainment',
    'Sports',
    'Science',
    'Health',
  ];

  @override
  Widget build(BuildContext context) {
    List<TextButton> quickFilterButtons = List.generate(
      quickFilters.length,
      (index) {
        return TextButton(
          onPressed: () {
            setState(() {
              _selectedFilter = quickFilters[index];
              _articlesFuture = fetchData(query: quickFilters[index]);
              _searchController.clear();
            });
          },
          child: Text(
            quickFilters[index],
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.newspaper_rounded),
            Text('Newsify'),
          ],
        ),
        title: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          child: Center(
            child: SizedBox(
              width: 600,
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search articles...',
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _articlesFuture = fetchData(query: value);
                    });
                  } else {
                    setState(() {
                      _articlesFuture = fetchData();
                    });
                  }
                },
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_rounded,
            ),
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: quickFilterButtons,
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: quickFilterButtons,
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Text(
                  'Error: ${snapshot.error}',
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.75,
                          mainAxisExtent: 350,
                        ),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return NewsCardBigScreen(
                            article: Article(
                              title: 'News Title',
                              description: "News description",
                              url: 'News url',
                            ),
                          );
                        },
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return NewsCardSmallScreen(
                            article: Article(
                                title: 'News Title',
                                description: "News description",
                                url: 'News url'),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final articles = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return NewsCardBigScreen(article: articles[index]);
                    },
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return NewsCardSmallScreen(article: articles[index]);
                    },
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
