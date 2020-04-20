import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../../services/NetworkHelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

class AndroidFirstPage extends StatefulWidget {
  const AndroidFirstPage({Key key}) : super(key: key);

  @override
  _AndroidFirstPageState createState() => _AndroidFirstPageState();
}

class _AndroidFirstPageState extends State<AndroidFirstPage> {

  int totalCases = 0;
  int deaths = 0;
  int recovered = 0;
  int confirmed = 0;
  bool valueReceived = false;

  void getData() async {
    NetworkHelper covidData = NetworkHelper('https://pomber.github.io/covid19/timeseries.json');
    var globalData = await covidData.getData();
    print(globalData["India"].reversed.toList()[0]);

    if(this.mounted){
    setState(() {
      recovered = globalData["India"].reversed.toList()[0]["recovered"];
      deaths = globalData["India"].reversed.toList()[0]["deaths"];
      confirmed = globalData["India"].reversed.toList()[0]["confirmed"];
      totalCases = recovered + deaths + confirmed;
      valueReceived = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(deaths.toDouble(), Color(0xFFAE4500), rankKey: 'Q1'),
          new CircularSegmentEntry(recovered.toDouble(), Color(0xFFFF9148), rankKey: 'Q2'),
          new CircularSegmentEntry(confirmed.toDouble(), Color(0xFFFA6400), rankKey: 'Q3'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Todays Report',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          valueReceived ? AnimatedCircularChart(
                key: _chartKey,
                size: Size(MediaQuery.of(context).size.width/1.5, MediaQuery.of(context).size.height/2.2),
                initialChartData: data,
                chartType: CircularChartType.Radial,
              ) :
              SpinKitRotatingCircle(
                color: Colors.white,
                size: 50.0,
              ),

          Row(
              children: <Widget>[
                Card(text: 'Confirmed',value: '${confirmed.toString()}',colour: Color(0xFFFA6400),),
                Card(text: 'Total Cases',value: '${totalCases.toString()}',colour: Colors.grey[400],)
              ],
            ),
          Row(
              children: <Widget>[
                Card(text: 'Recovered',value: '${recovered.toString()}',colour: Color(0xFFFF9148),),
                Card(text: 'Deaths',value: '${deaths.toString()}',colour: Color(0xFFAE4500),)
              ],
            ),
          ],
        ),
      )
    );
  }
}

class Card extends StatelessWidget {

  Card({@required this.text, @required this.value, this.colour});

  final String text;
  final String value;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: colour
        ),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(left: 12.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 12.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
