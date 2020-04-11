import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon_corona_app/models/news.dart';
import 'package:falcon_corona_app/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

const url = "http://newsapi.org/v2/top-headlines?q=corona&sortBy=publishedAt&language=en&apiKey=0fa3ff9e6c2b4a7e93c2ccc823fd3e8b";


Future<NewsModel> newsArticles;

Future<NewsModel> getNews() async{
  final response = await http.get(url);
  final news = newsModelFromJson(response.body);
  return news;
}

class ShimmerAnimation extends StatelessWidget {
	double shimmerWidth;
	double shimmerHeight;
	int duration;

	ShimmerAnimation({this.shimmerHeight, this.shimmerWidth, this.duration});

	@override
	Widget build(BuildContext context) {
		return Shimmer.fromColors(
			period: Duration(milliseconds: duration),
			baseColor: Colors.grey[500],
			highlightColor: Colors.white,
			child: Container(
				width: shimmerWidth,
				height: shimmerHeight,
				decoration: BoxDecoration(
					color: Colors.black,
					borderRadius: BorderRadius.circular(10)
				),
			),
		);
	}
}


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>{

  @override
  void initState() {
    super.initState();
    newsArticles = getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SafeArea(
            child: FutureBuilder<NewsModel>(
              future: newsArticles,
              builder: (ctx, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 10, 0, 9),
                          child: Text("Today's Top Healdines", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.grey
                            ),
                          ),
                        )
                      ),
                      ShimmerAnimation(
                        shimmerHeight: MediaQuery.of(context).size.height/3,
                        shimmerWidth: MediaQuery.of(context).size.width/1.1,
                        duration: 1000,
                      ),
                      Row(
                        children: <Widget>[
                          ShimmerAnimation(
                            shimmerHeight: MediaQuery.of(context).size.height/3,
                            shimmerWidth: MediaQuery.of(context).size.width/2.1,
                            duration: 500,
                          ),
                          ShimmerAnimation(
                            shimmerHeight: MediaQuery.of(context).size.height/3,
                            shimmerWidth: MediaQuery.of(context).size.width/2.1,
                            duration: 500,
                          ),
                        ],
                      ),
                    ],
                  );
                }
                else{
                  return Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 10, 0, 9),
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
                            // LINK WEBVIEW CODE HERE PLS
                            // onTap: (){Navigator.push(
                            // context,
                            // new MaterialPageRoute(
                            //   builder: (BuildContext context) => new NewsArticle(
                            //     newsURL: snapshot.data.articles[index].url,
                            //     newsDescription: snapshot.data.articles[index].description,
                            //     newsSource: snapshot.data.articles[index].source.name,
                            //     newsTitle: snapshot.data.articles[index].title,
                            //   )
                            // ));},
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.articles[index].urlToImage,
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => SpinKitWave(color: Colors.orange),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                    Container(
                                      child: ListTile(
                                        isThreeLine: true,
                                        title: Text(snapshot.data.articles[index].title.length>100 
                                        ? '${snapshot.data.articles[index].title.substring(0,70)}...': snapshot.data.articles[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(snapshot.data.articles[index].source.name),
                                            Text("${(DateTime.now().difference(snapshot.data.articles[index].publishedAt).inHours+1)} hour(s) ago")
                                          ],
                                        )
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
          ),
    );
  }
}