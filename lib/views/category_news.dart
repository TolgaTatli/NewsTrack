import 'package:flutter/material.dart';
import 'package:newstrack/helpers/news.dart';
import 'package:newstrack/models/article_model.dart';
import 'package:newstrack/views/home.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({super.key, required this.category});

  final String category;

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "News",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: 4),
              ),
              const Text(
                "Track",
                style: TextStyle(
                    color: Color.fromARGB(255, 162, 38, 29),
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: 12),
              ),
              Opacity(
                opacity: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(
                    Icons.save,
                  ),
                ),
              )
            ],
          ),
          elevation: 0,
        ),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.red,
                  backgroundColor: Colors.black,
                  strokeAlign: 4,
                  strokeWidth: 9,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Text(
                              widget.category.toUpperCase(),
                              style: const TextStyle(
                                letterSpacing: 1.4,
                                color: Color.fromARGB(255, 130, 12, 12),
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          itemCount: articles.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BlogTile(
                              url: articles[index].url,
                              imageUrl: articles[index].urlToImage,
                              title: articles[index].title,
                              description: articles[index].description,
                            );
                          })
                    ],
                  ),
                ),
              ));
  }
}
