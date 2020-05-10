import 'package:falcon_corona_app/models/district_cases.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../services/mapServices.dart';
import '../services/shared.dart';
import '../widgets/snackBar.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Marker> allMarkers = [];
  List<LatLng> polygonCoords = List();
  Set<Polygon> polygonSet = new Set();
  Set<Circle> circles = Set();
  dynamic matchedcoords;
  final coords = [];
  LatLng initialPosition;
  bool busy = true;

  GoogleMapController _controller;

  List<TargetFocus> targets = List();

  GlobalKey keyButton1 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: busy
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(
                      margin: EdgeInsets.all(30.0),
                      child: Text(
                        'Please wait while we fetch the latest data for you, this may take some time, but\'s only for first time.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(21.000, 72.00), zoom: 4.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                circles: circles,
              ),
            ),
    );
  }

  Future<List<DistrictCases>> getDistrictCases() async {
    final response = await http
        .get("https://api.covid19india.org/v2/state_district_wise.json");

    final cases = districtCasesFromJson(response.body);
    return cases;
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    //_addCircles();
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: keyButton1,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Refresh map data with the help of this button",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }

  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        finish: () {},
        clickTarget: (target) {},
        clickSkip: () {})
      ..show();
  }

  void _addCircles() async {
    final casesData = await getDistrictCases();
    for (int i = 0; i < casesData.length; i++) {
      for (int j = 0; j < casesData[i].districtData.length; j++) {
        if (casesData[i].districtData[j].district == "Unknown") {
          continue;
        }
        try {
          //print(casesData[i].districtData[j].district);
          final addresses = await Geolocator()
              .placemarkFromAddress(casesData[i].districtData[j].district);
          var lat = addresses.first.position.latitude;
          var long = addresses.first.position.longitude;
          final latlng = LatLng(lat, long);
          coords.add([latlng, casesData[i].districtData[j].confirmed]);
        } on Exception {
          continue;
        }
      }
    }
    setState(() {
      for (int k = 0; k < coords.length; k++) {
        double radius = 0;
        int color = 0;
        if (coords[k][1] < 50) {
          radius = 2500;
          color = 300;
        } else if (coords[k][1] < 100) {
          radius = 5000;
          color = 400;
        } else if (coords[k][1] < 200) {
          radius = 10000;
          color = 500;
        } else if (coords[k][1] < 300) {
          radius = 20000;
          color = 600;
        } else if (coords[k][1] < 500) {
          radius = 30000;
          color = 700;
        } else {
          radius = 50000;
          color = 900;
        }
        circles.add(Circle(
            circleId: CircleId(coords[k][1].toString()),
            center: coords[k][0],
            radius: radius,
            strokeColor: Colors.red[color],
            strokeWidth: 5,
            fillColor: Colors.red[color]));
      }
      print("HEREEEEEEE" + circles.toString());
    });
  }

  void _afterLayout(_) {
    if (Shared.showMapTutorial()) {
      Future.delayed(Duration(milliseconds: 100), () {
        showTutorial();
      });
    }
  }

  void _initializePage() async {
    setState(() {
      busy = true;
    });
    allMarkers = await MapService.buildMarkers();
    //circles=await MapService.buildMapCircles();
    circles = Shared.getAffectedCitiesCircles();
    setState(() {
      busy = false;
    });
    showSnackbar(
        key: keyButton1,
        context: context,
        content:
            'Last Updated at ${Shared.getLastUpdatedStamp()['date']} at ${Shared.getLastUpdatedStamp()['time']}',
        label: 'Refresh',
        labelPressAction: () async {
          print('Update all locations again!');
          //busy=true;
          circles = await MapService.buildMapCircles(context: context);
          if (circles.isNotEmpty) {
            //busy=false;
          }
        });
  }
}
