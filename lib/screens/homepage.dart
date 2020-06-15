import 'package:flutter/material.dart';
import 'package:newsapp/models/category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/screens/category_news_screen.dart';
import '../widgets/newstile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading;
  var newslist;

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loading = true;
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          actions: [
            Container(padding: EdgeInsets.all(10), child: Icon(Icons.search))
          ],
          centerTitle: true,
          title: Text(
            'DailyNews',
            style: TextStyle(fontSize: 25),
          ),
          elevation: 0.0,
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  //Category
                  Container(
                    height: 320,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categorieslist.categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CategoryCard(
                            imgUrl:
                                categorieslist.categories[index].imageAssetUrl,
                            categoryName:
                                categorieslist.categories[index].categoryname,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Latest News',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  //Newslist
                  Container(
                    padding: EdgeInsets.only(top: 1),
                    child: ListView.builder(
                      itemCount: newslist.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NewsTile(
                              articleUrl: newslist[index].articleUrl,
                              title: newslist[index].title,
                              subtitle: newslist[index].description,
                              imgUrl: newslist[index].imgUrl,
                            ));
                      },
                    ),
                  ),
                ],
              ));
  }
}

class CategoryCard extends StatelessWidget {
  final String imgUrl, categoryName;

  CategoryCard({this.imgUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNewsScreen(
                      category: categoryName,
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              height: 300,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 300,
            width: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(10)),
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
