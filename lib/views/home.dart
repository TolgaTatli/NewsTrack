import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newstrack/helpers/data.dart';
import 'package:newstrack/helpers/news.dart';
import 'package:newstrack/models/article_model.dart';
import 'package:newstrack/models/category_modal.dart';
import 'package:newstrack/views/article_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModal> categories = [];
  List<ArticleModel> articles = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 24, letterSpacing: 4),
            ),
            Text(
              "Track",
              style: TextStyle(
                  color: Color.fromARGB(255, 162, 38, 29),
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  letterSpacing: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    //  Categories
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),

                    // Blogs
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
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final imageUrl, categoryName;
  const CategoryTile({super.key, this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              height: 60,
              child: Text(
                categoryName,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  const BlogTile(
      {super.key,
      required this.url,
      required this.imageUrl,
      required this.title,
      required this.description});

  final String imageUrl, title, description, url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              description,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
