import 'dart:async';
import 'dart:convert';

import 'package:falcon_corona_app/models/coordinate.dart';
import 'package:falcon_corona_app/screens/alert_screen.dart';
import 'package:falcon_corona_app/screens/history_screen.dart';
import 'package:falcon_corona_app/screens/warning_screen.dart';
import 'package:falcon_corona_app/services/databaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

import '../services/shared.dart';
import 'aok_screen.dart';

Future<void> addNewEntry(latitude, longitude) async {
  Database database=await DatabaseService().initDatabase();
  Coordinate coordinate=Coordinate(
      latitude: latitude,
      longitude: longitude,
      datetime: DateTime.now().toString()
  );
  print(coordinate.toJson());
  DatabaseService().insertCoordinate(database, coordinate);	
  return Future.value();
}


void maybeStartFGS() async {
  print('Starting FGS');
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  _serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return;
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    return;
  }
}
  print('Done!');
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(5);

    //necessity of editMode is dubious (see function comments)
    await ForegroundService.notification.startEditMode();

    await ForegroundService.notification
        .setTitle("Example Title: ${DateTime.now()}");
    await ForegroundService.notification
        .setText("Example Text: ${DateTime.now()}");

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }
}

Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

void foregroundServiceFunction() async {
  print('(__)');
  _locationData = await location.getLocation();
  print(_locationData);
  // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // print(position);
  // debugPrint("The current location is: ${position.latitude}, ${position.longitude}");
  // addNewEntry(position.latitude, position.longitude);

  ForegroundService.notification.setText("The time was: ${DateTime.now()}");
  }



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var childRef;
final DBRef=FirebaseDatabase.instance.reference();

var uuid = new Uuid();

class _HomeScreenState extends State<HomeScreen> {

  Database database;

  void uploadDataToFirebase() async {
    dynamic coordinates=await DatabaseService().getAllRawCoordinates(database);
    dynamic a=List.generate(coordinates.length, (i) {
			return <dynamic, dynamic>{
        'latitude': coordinates[i]['latitude'],
        'longitude': coordinates[i]['longitude'],
        'datetime': coordinates[i]['datetime'],
      };
		});
    DBRef.child("users").child(uuid.v4())
    .set(a);
  }

  void _setUpListener(){
    final childRef=DBRef.child('users').onChildAdded.listen(_onChageDetection);
    // final childRef=DBRef.onChildChanged.listen(_onChageDetection);
    print(childRef);
    print("Listener Set!");
  }

  void _onChageDetection(Event event){
    //print(event.snapshot);
    print("Change detected!");
    print(event.snapshot.value);
    print(event.snapshot);
    onFirebaseChange(event.snapshot.value);
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

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }
  int _currentIndex = 0;
  final List<Widget> _children = [
    WarningScreen(),
    HistoryScreen(),
    Shared.isCaseReported()?AOKScreen():AlertScreen(),
  ];


	void onFirebaseChange(dynamic dummyDataList) async {
    print('inFirebaseChange');
    dynamic matchedCoords=[];
		List<Coordinate> coordList=await DatabaseService().getAllCoordinates(database);
		for(int i=0;i<coordList.length;i++) {
			for(int j=0;j<dummyDataList.length;j++) {
				if(dummyDataList[j]['datetime']==coordList[i].datetime && dummyDataList[i]['latitude']==coordList[i].latitude) {
          print('Match!');
					print(dummyDataList[i]);
          matchedCoords.add(dummyDataList[i]);
				}
			}
		}
    Shared.setMatchedCoordinates(json.encode(matchedCoords));
    print('Stored Locally!');
	}

  Future<void> _initDatabase() async {
    database=await DatabaseService().initDatabase();
    return Future.value();
  }

	void _initializePage() async {
		//await _listenLocation();
		// timer = Timer.periodic(Duration(seconds: 10), (Timer t) => addNewEntry());
    maybeStartFGS();
    await _initDatabase();
    _setUpListener();
	}

  @override
  void initState() {
		_initializePage();
    super.initState();
  }

  @override
  void dispose() {
    //_stopListen();
		//timer?.cancel();
    super.dispose();
    childRef.cancel();
  }

    
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            title: Text('Warnings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            title: Text('Alert'),
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFFA6400),
        onTap: onTabTapped
      )
    );
  }
}
