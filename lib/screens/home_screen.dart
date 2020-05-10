import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../models/coordinate.dart';
import '../services/databaseService.dart';
import '../services/firebaseService.dart';
import '../services/shared.dart';
import '../services/sharedKeys.dart';
import 'alert_screen.dart';
import 'aok_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import 'warning_screen.dart';

var childRef;

final DBRef = FirebaseDatabase.instance.reference();

//Location location = new Location();

//bool _serviceEnabled;
//PermissionStatus _permissionGranted;
//LocationData _locationData;

var uuid = new Uuid();

Future<void> addNewEntry(latitude, longitude) async {
  Database database = await DatabaseService().initDatabase();
  Coordinate coordinate = Coordinate(
      latitude: latitude,
      longitude: longitude,
      datetime: DateTime.now().toString());
  DatabaseService().insertCoordinate(database, coordinate);
  return Future.value();
}

void foregroundServiceFunction() async {
  //_locationData = await location.getLocation();
  //print(_locationData);
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);
  debugPrint(
      "The current location is: ${position.latitude}, ${position.longitude}");
  addNewEntry(position.latitude, position.longitude);

  ForegroundService.notification.setText("The time was: ${DateTime.now()}");
}

void maybeStartFGS() async {
  print('Starting FGS');
  //final Geolocator geolocator = Geolocator()
  // ..forceAndroidLocationManager = true;
  GeolocationStatus geolocationStatus =
      await Geolocator().checkGeolocationPermissionStatus();
  print(geolocationStatus);
  if ((geolocationStatus == GeolocationStatus.denied ||
      geolocationStatus == GeolocationStatus.disabled)) {
    print('Location permission not given! Asking for permission');
    await Permission.locationWhenInUse.request();
  }
//    _serviceEnabled = await location.serviceEnabled();
//  if (!_serviceEnabled) {
//    _serviceEnabled = await location.requestService();
//    if (!_serviceEnabled) {
//      return;
//    }
//  }
//
//  _permissionGranted = await location.hasPermission();
//  if (_permissionGranted == PermissionStatus.denied) {
//    _permissionGranted = await location.requestPermission();
//    if (_permissionGranted != PermissionStatus.granted) {
//      return;
//    }
//  }
  print('Done!');
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(
        5); //necessity of editMode is dubious (see function comments) await ForegroundService.notification.startEditMode();
    await ForegroundService.notification
        .setTitle("Example Title: ${DateTime.now()}");
    await ForegroundService.notification
        .setText("Example Text: ${DateTime.now()}");

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database database;

  List<TargetFocus> targets = List();

  int _currentIndex = 0;

  List<Widget> _children() => [
    WarningScreen(showTutorial: showTutorial),
    StatsScreen(),
    HistoryScreen(),
    Shared.isCaseReported() ? AOKScreen() : AlertScreen(),
    //AlertScreen(),
  ];

  // GlobalKey keyButton = GlobalKey();
  // GlobalKey keyButton2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();
    return Scaffold(
        body: children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.warning,
                  key: SharedKeys.keyButton5
                ),
                title: Text('Warnings'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.collections_bookmark,
                  key: SharedKeys.keyButton1,
                ),
                title: Text('Reports'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  key: SharedKeys.keyButton2,
                ),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon( Icons.add_alert,
                  key: SharedKeys.keyButton3,
                ),
                title: Text('Alert'),
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Color(0xFFFA6400),
            unselectedItemColor: Color(0xFFFA6400),
            onTap: onTabTapped));
  }

  // Future<void> _listenLocation() async {
  //   _locationSubscription =
  //       location.onLocationChanged.handleError((dynamic err) {
  //     _locationSubscription.cancel();
  //   }).listen((LocationData currentLocation) {
  //     setState(() {
  //       _location = currentLocation;
  //     });
  //   });
  // }

  // Future<void> _stopListen() async {
  //   _locationSubscription.cancel();
  // }

  @override
  void dispose() {
    //_stopListen();
    //timer?.cancel();
    super.dispose();
    childRef.cancel();
  }

  @override
  void initState() {
    _initializePage();
    super.initState();
  }

  void onFirebaseChange(dynamic dummyDataList) async {
    print('inFirebaseChange');
    dynamic matchedCoords = [];
    List<Coordinate> coordList =
        await DatabaseService().getAllCoordinates(database);
    for (int i = 0; i < coordList.length; i++) {
      for (int j = 0; j < dummyDataList.length; j++) {
        if (dummyDataList[j]['datetime'] == coordList[i].datetime &&
            dummyDataList[i]['latitude'] == coordList[i].latitude) {
          print('Match!');
          print(dummyDataList[i]);
          matchedCoords.add(dummyDataList[i]);
        }
      }
    }
    Shared.setMatchedCoordinates(json.encode(matchedCoords));
    print('Stored Locally!');
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void uploadDataToFirebase() async {
    dynamic coordinates =
        await DatabaseService().getAllRawCoordinates(database);
    dynamic a = List.generate(coordinates.length, (i) {
      return <dynamic, dynamic>{
        'latitude': coordinates[i]['latitude'],
        'longitude': coordinates[i]['longitude'],
        'datetime': coordinates[i]['datetime'],
      };
    });
    DBRef.child("users").child(uuid.v4()).set(a);
  }

  Future<void> _initDatabase() async {
    database = await DatabaseService().initDatabase();
    return Future.value();
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, finish: () {
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    print(Shared.showWarningTutorial());
    if (Shared.showWarningTutorial()) {
      Future.delayed(Duration(milliseconds: 100), () {
        showTutorial();
      });
    }
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: SharedKeys.keyButton,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Start/Stop location tracking",
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
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: SharedKeys.keyButton5,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Get all necessary warnings and alerts realted to possible encounters",
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
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: SharedKeys.keyButton1,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Gain all round covid updates from trustful sources",
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
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: SharedKeys.keyButton2,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Check data with the help of map",
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
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: SharedKeys.keyButton3,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Report your case",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
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
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: SharedKeys.keyButton4,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Restart tutorial",
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
      shape: ShapeLightFocus.Circle,
    ));
  }

  void _initializePage() async {
    //await _listenLocation();
    // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => addNewEntry());
    maybeStartFGS();
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    await _initDatabase();
    //_setUpListener();
    FirebaseService.setUpListener();
  }

  void _onChangeDetection(Event event) {
    //print(event.snapshot);
    print("Change detected!");
    print(event.snapshot.value);
    print(event.snapshot);
    onFirebaseChange(event.snapshot.value);
  }

  void _setUpListener() {
    final childRef =
        DBRef.child('users').onChildAdded.listen(_onChangeDetection);
    // final childRef=DBRef.onChildChanged.listen(_onChageDetection);
    print(childRef);
    print("Listener Set!");
  }
}
