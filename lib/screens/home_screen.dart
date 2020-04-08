import 'dart:async';
import 'dart:convert';

import 'package:falcon_corona_app/models/coordinate.dart';
import 'package:falcon_corona_app/screens/alert_screen.dart';
import 'package:falcon_corona_app/screens/history_screen.dart';
import 'package:falcon_corona_app/screens/warning_screen.dart';
import 'package:falcon_corona_app/services/databaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../services/shared.dart';
import 'aok_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final Location location = Location();

  var childRef;
  final DBRef=FirebaseDatabase.instance.reference();

  var uuid = new Uuid();

	Timer timer;
  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
	Database database;

  void uploadDataToFirebase() async {
    // DBRef.child("users").set(<dynamic, dynamic>{
    //       "something": "something"
    //     });
    dynamic coordinates=await DatabaseService().getAllRawCoordinates(database);
    // print(coordinates);
    dynamic a=List.generate(coordinates.length, (i) {
      // print(i);
      // print(coordinates[i]['datetime']);
			return <dynamic, dynamic>{
        'latitude': coordinates[i]['latitude'],
        'longitude': coordinates[i]['longitude'],
        'datetime': coordinates[i]['datetime'],
      };
		});
    print(coordinates.runtimeType);
    print(a.runtimeType);
    // DBRef.child("users")
    // .set(a);
    DBRef.child("users").child(uuid.v4())
    .set(a);

    // for(int i=0; i<a.length;i++) {
    //   DBRef.child("users").push()
    //   .set(<dynamic, dynamic>{
    //         "something": "something"
    //       });
    // }
  }

  void _setUpListener(){
    // DBRef.child("users").set(<dynamic, dynamic>{
    //       "something": "something"
    //     });
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

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      setState(() {
        _location = currentLocation;
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

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

	Future<void> _initDatabase() async {
		print('Initializtion Started!');
		Database db=await DatabaseService().initDatabase();
		setState(() {
				database=db;
			});	
	}
	
	Future<void> addNewEntry() {
		Coordinate coordinate=Coordinate(
				latitude: _location.latitude,
				longitude: _location.longitude,
				datetime: DateTime.now().toString()
		);
		print(coordinate.toJson());
		DatabaseService().insertCoordinate(database, coordinate);	
		return Future.value();
	}

	void onFirebaseChange(dynamic dummyDataList) async {
    print('inFirebaseChange');
    //final SharedPreferences prefs = await _prefs;
		// dynamic dummyDataList=[
		// 	{'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:09:41.927760'},
    //   {'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:12:56.927608'}, 
		// 	{'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:14:41.927972'}, 
		// ];
    dynamic matchedCoords=[];
		List<Coordinate> coordList=await DatabaseService().getAllCoordinates(database);
		for(int i=0;i<coordList.length;i++) {
			for(int j=0;j<dummyDataList.length;j++) {
				if(dummyDataList[j]['datetime']==coordList[i].datetime && dummyDataList[i]['latitude']==coordList[i].latitude) {
          //print('Match!');
					//print(dummyDataList[i]);
          matchedCoords.add(dummyDataList[i]);
				}
			}
		}
    //prefs.setString('matchedCoords', json.encode(matchedCoords));
    print('<__>');
    print(matchedCoords);
    Shared.setMatchedCoordinates(json.encode(matchedCoords));
    print(await Shared.getMatchedCoordinates());
    print('Stored Locally!');
	}

	void _initializePage() async {
		await _listenLocation();
		await _initDatabase();
		// timer = Timer.periodic(Duration(seconds: 10), (Timer t) => addNewEntry());
    _setUpListener();
    // uploadDataToFirebase();
		// onFirebaseChange();
	}

  @override
  void initState() {
		_initializePage();
    super.initState();
  }

  @override
  void dispose() {
    _stopListen();
		timer?.cancel();
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
