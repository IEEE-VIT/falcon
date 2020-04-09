import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon_corona_app/models/news.dart';
import 'package:falcon_corona_app/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

const url = "http://newsapi.org/v2/top-headlines?q=corona&sortBy=publishedAt&language=en&apiKey=0fa3ff9e6c2b4a7e93c2ccc823fd3e8b";


Future<NewsModel> newsArticles;

Future<NewsModel> getNews() async{
  final response = await http.get(url);
  final news = newsModelFromJson(response.body);
  return news;
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  @override
  void initState() {
    super.initState();
    newsArticles = getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          FutureBuilder<NewsModel>(
            future: newsArticles,
            builder: (ctx, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Column(
                  children: <Widget>[
                    Text("Today's top healdines"),
                    CircularProgressIndicator(),
                  ],
                );
              }
              else{
                return Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 10, 0,10),
                        child: Text("Today's Top Healdines", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.grey
                          ),
                        ),
                      )
                    ),
                    Expanded(
                     child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        staggeredTileBuilder: (int index) {
                          print(index);
                          if(index==0){
                            return StaggeredTile.count(4, 3);
                          }
                          else if(index%3==0){
                            return StaggeredTile.count(4, 3);
                          }
                          else{
                            return StaggeredTile.count(2, 3);
                          }
                        },
                        crossAxisCount: 4,
                        itemCount: snapshot.data.articles.length,
                        itemBuilder: (ctx, index) => 
                        GestureDetector(
                          onTap: (){Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => new NewsArticle(
                              newsURL: snapshot.data.articles[index+1].url,
                              newsDescription: snapshot.data.articles[index+1].description,
                              newsSource: snapshot.data.articles[index+1].source.name,
                              newsTitle: snapshot.data.articles[index+1].title,
                            )
                          ));},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.articles[index+1].urlToImage,
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                                  child: Text(snapshot.data.articles[index+1].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
    );
  }
}