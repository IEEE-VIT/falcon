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
  //print(position);
 // debugPrint(
 //     "The current location is: ${position.latitude}, ${position.longitude}");
  addNewEntry(position.latitude, position.longitude);

  //ForegroundService.notification.setText("The time was: ${DateTime.now()}");
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
        .setTitle("Falcon is keenly protecting you");
    await ForegroundService.notification
        .setText("Any possible interactions will be reported");

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }
  await ForegroundService.notification
      .setPriority(AndroidNotificationPriority.LOW);
  // await ForegroundService.setupIsolateCommunication((data) {
  // });
}

class ScreenWithIndex {
  final Widget screen;
  final int index;

  ScreenWithIndex({this.screen, this.index});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin<HomeScreen> {
  Database database;

  List<TargetFocus> targets = List();

  int _currentIndex = 0;
  List<Key> _destinationKeys;
  List<AnimationController> _faders;

  List<ScreenWithIndex> _children() => [
        ScreenWithIndex(
          screen: StatsScreen(),
          index: 0,
        ),
        ScreenWithIndex(
          screen: WarningScreen(showTutorial: showTutorial, targets: targets,),
          index: 1,
        ),
        ScreenWithIndex(
          screen: HistoryScreen(),
          index: 2,
        ),
        ScreenWithIndex(
          screen: Shared.isCaseReported() ? AOKScreen() : AlertScreen(),
          index: 3,
        ),
      ];

  void _mapTutorialScreen() {
    if (_currentIndex == 0) {
      if (Shared.showStatsTutorial()) {
        Future.delayed(Duration(milliseconds: 100), () {
          showTutorial(targets: SharedKeys.statsTargets);
          showTutorial(targets: targets);
        });
      }
    }
    else if (_currentIndex == 1) {
      if (Shared.showWarningTutorial()) {
        Future.delayed(Duration(milliseconds: 100), () {
          showTutorial(targets: SharedKeys.warningTargets);
        });
      }
    }  else if (_currentIndex == 2) {
      if (Shared.containskey('affectedCitiesCircles')) {
        if(Shared.showMapTutorial()) {
        Future.delayed(Duration(milliseconds: 100), () {
          showTutorial(targets: SharedKeys.mapTargets);
        });
        }
      }
    } else if (_currentIndex == 3) {
      if (Shared.showReportTutorial()) {
        Future.delayed(Duration(milliseconds: 100), () {
          showTutorial(targets: SharedKeys.reportTargets);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final List<ScreenWithIndex> children = _children();
    final Function children = _children;
    return Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: children
                .call()
                .map((ScreenWithIndex screen) {
                  final Widget view = FadeTransition(
                    opacity: _faders[screen.index]
                        .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                    child: KeyedSubtree(
                        key: _destinationKeys[screen.index],
                        child: children.call()[screen.index].screen),
                  );
                  if (screen.index == _currentIndex) {
                    _mapTutorialScreen();
                    _faders[screen.index].forward();
                    return view;
                  } else {
                    _faders[screen.index].reverse();
                    if (_faders[screen.index].isAnimating) {
                      return IgnorePointer(child: view);
                    }
                    return Offstage(child: view);
                  }
                })
                .cast<Widget>()
                .toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.collections_bookmark,
                  key: SharedKeys.keyButton,
                ),
                title: Text('Reports'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.warning,
                  key: SharedKeys.keyButton1,
                ),
                title: Text('Warnings'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  key: SharedKeys.keyButton2,
                ),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_alert,
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
    for (AnimationController controller in _faders) controller.dispose();
    childRef.cancel();
  }

  @override
  void initState() {
    //533
    _initializePage();
    _faders =
        _children.call().map<AnimationController>((ScreenWithIndex screen) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(_children.call().length, (int index) => GlobalKey())
            .toList();
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

  void showTutorial({@required List<TargetFocus> targets}) {
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
  }


  void _initializePage() async {
    //await _listenLocation();
    // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => addNewEntry());
    maybeStartFGS();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    await _initDatabase();
    //_setUpListener();
    FirebaseService.setUpListener();
  }
}
