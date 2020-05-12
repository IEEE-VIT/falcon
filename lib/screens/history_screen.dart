import 'package:falcon_corona_app/models/district_cases.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../services/mapServices.dart';
import '../services/shared.dart';
import '../services/sharedKeys.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            iconSize: 36.0,
            onPressed: () {
              initializeMapPage();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.red,
            ),
          ),
        ],
      ),
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
                   // Container(
                   //   margin: EdgeInsets.all(10.0),
                   //   child: LiquidCircularProgressIndicator(
                   //     value: 0.25, // Defaults to 0.5.
                   //     valueColor: AlwaysStoppedAnimation(Colors
                   //         .pink), // Defaults to the current Theme's accentColor.
                   //     backgroundColor: Colors
                   //         .white, // Defaults to the current Theme's backgroundColor.
                   //     borderColor: Colors.red,
                   //     borderWidth: 5.0,
                   //     direction: Axis.horizontal, center: Text("Loading..."),
                   //   ),
                   // ),
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
    initializeMapPage();
    SharedKeys.initMapTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    //_addCircles();
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

  void _afterLayout(_) {
    if (Shared.showMapTutorial()) {
      Future.delayed(Duration(milliseconds: 100), () {
        showTutorial();
      });
    }
  }

  void initializeMapPage() async {
    setState(() {
      busy = true;
    });
    if(!Shared.containskey('affectedCitiesCircles')) {
      print('Getting all the circles as its first time entry');
      await MapService.buildMapCircles();
    }
    allMarkers = await MapService.buildMarkers();
    //circles=await MapService.buildMapCircles();
    circles = Shared.getAffectedCitiesCircles();
    setState(() {
      busy = false;
    });
    showSnackbar(
        key: SharedKeys.mapKeyButton1,
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
          initializeMapPage();
        });
  }
}
