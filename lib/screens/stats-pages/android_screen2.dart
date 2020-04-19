import 'package:flutter/material.dart';
import '../../services/NetworkHelper.dart';
import 'news_article.dart';

class AndroidSecondPage extends StatefulWidget {
  @override
  _AndroidSecondPageState createState() => _AndroidSecondPageState();
}

class _AndroidSecondPageState extends State<AndroidSecondPage> {
  Future<List> getData() async {
    NetworkHelper covidData = NetworkHelper(
        'http://newsapi.org/v2/top-headlines?country=in&q=corona&sortBy=publishedAt&apiKey=d9fa391aacfe428e81b8c6002ea8a507');
    var covidNews = await covidData.getData();
    var articles = covidNews['articles'];
    print(articles);

    return articles;
  }

  void initState() {
    super.initState();
    getData();
  }

  Future<Null> refresh() async {
    await getData();
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      child: Center(
                    child: Text('Loading...'),
                  ));
                } else {
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsArticle(
                                      newsURL: snapshot.data[index]['url'],
                                      newsSource: snapshot.data[index]['source']['name'],
                                      newsTitle: snapshot.data[index]['title'],
                                      newsDescription: snapshot.data[index]['description'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    snapshot.data[index]['title'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data[index]['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      snapshot.data[index]['urlToImage'],
                                      scale: 10,
                                      filterQuality: FilterQuality.low,
                                      height: 100,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      colorBlendMode: BlendMode.darken,
                                    ),
                                  ),
                                  isThreeLine: true,
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              })),
    );
  }
}
