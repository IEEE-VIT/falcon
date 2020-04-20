import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../../services/NetworkHelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final GlobalKey<AnimatedCircularChartState> _chartKey =
    new GlobalKey<AnimatedCircularChartState>();

class AndroidFirstPage extends StatefulWidget {
  const AndroidFirstPage({Key key}) : super(key: key);

  @override
  _AndroidFirstPageState createState() => _AndroidFirstPageState();
}

class _AndroidFirstPageState extends State<AndroidFirstPage> {
  int totalCases = 0;
  int prevTotalCases = 0;
  int deaths = 0;
  int recovered = 0;
  int confirmed = 0;
  int prevDayDeaths = 0;
  int prevDayRecovered = 0;
  int prevDayConfirmed = 0;
  bool valueReceived = false;
  String deathPercentage = "0.0";
  String recoveredPercentage = "0.0";
  String confirmedPercentage = "0.0";

  void getData() async {
    NetworkHelper covidData =
        NetworkHelper('https://pomber.github.io/covid19/timeseries.json');
    var globalData = await covidData.getData();
    print(globalData["India"].reversed.toList()[0]);

    if (this.mounted) {
      setState(() {
        recovered = globalData["India"].reversed.toList()[0]["recovered"];
        deaths = globalData["India"].reversed.toList()[0]["deaths"];
        confirmed = globalData["India"].reversed.toList()[0]["confirmed"];
        prevDayRecovered = globalData["India"].reversed.toList()[1]["recovered"];
        prevDayDeaths = globalData["India"].reversed.toList()[1]["deaths"];
        prevDayConfirmed = globalData["India"].reversed.toList()[1]["confirmed"];
        totalCases = recovered + deaths + confirmed;
        prevTotalCases = prevDayRecovered + prevDayDeaths + prevDayConfirmed;
        deathPercentage = ((deaths / totalCases) * 100).toStringAsFixed(2);
        recoveredPercentage = ((recovered / totalCases) * 100).toStringAsFixed(2);
        confirmedPercentage = ((confirmed / totalCases) * 100).toStringAsFixed(2);
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
          new CircularSegmentEntry(recovered.toDouble(), Color(0xFFFF9148),
              rankKey: 'Q2'),
          new CircularSegmentEntry(confirmed.toDouble(), Color(0xFFFA6400),
              rankKey: 'Q3'),
          new CircularSegmentEntry(deaths.toDouble(), Color(0xFFAE4500),
              rankKey: 'Q1'),
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
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          valueReceived
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartKey,
                        size: Size(MediaQuery.of(context).size.width / 1.5,
                            MediaQuery.of(context).size.height / 2.2),
                        initialChartData: data,
                        chartType: CircularChartType.Radial,
                      ),
                      Positioned(
                        top: 40,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Death $deathPercentage%',
                              style: TextStyle(color: Color(0xFFAE4500)),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xFFEAD0BF),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Recovered $recoveredPercentage%',
                              style: TextStyle(color: Color(0xFFFF9148)),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xFFFBD7BF),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Confirmed $confirmedPercentage%',
                              style: TextStyle(color: Color(0xFFFA6400)),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xFFFCE3D1),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SpinKitRotatingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
          Row(
            children: <Widget>[
              Card(
                text: 'Confirmed',
                value: confirmed > prevDayConfirmed
                    ? '${confirmed.toString()}(+${confirmed - prevDayConfirmed})'
                    : '${confirmed.toString()}(-${prevDayConfirmed - confirmed})',
                colour: Color(0xFFFA6400),
              ),
              Card(
                text: 'Total Cases',
                value: totalCases > prevTotalCases
                    ? '${totalCases.toString()}(+${totalCases - prevTotalCases})'
                    : '${totalCases.toString()}(-${prevTotalCases - totalCases})',
                colour: Colors.grey[400],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Card(
                text: 'Recovered',
                value: recovered > prevDayRecovered
                    ? '${recovered.toString()}(+${recovered - prevDayRecovered})'
                    : '${recovered.toString()}(-${prevDayRecovered - recovered})',
                colour: Color(0xFFFF9148),
              ),
              Card(
                text: 'Deaths',
                value: deaths > prevDayDeaths
                    ? '${deaths.toString()}(+${deaths - prevDayDeaths})'
                    : '${deaths.toString()}(-${prevDayDeaths - deaths})',
                colour: Color(0xFFAE4500),
              )
            ],
          ),
        ],
      ),
    ));
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
            borderRadius: BorderRadius.circular(8.0), color: colour),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(value,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
