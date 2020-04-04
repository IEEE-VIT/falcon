
import 'dart:async';

import 'package:falcon_corona_app/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sqflite/sqflite.dart';

import 'package:falcon_corona_app/screens/alert_screen.dart';
import 'package:falcon_corona_app/screens/warning_screen.dart';
import 'package:falcon_corona_app/services/databaseService.dart';
import 'package:falcon_corona_app/models/coordinate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Location location = Location();

	Timer timer;
  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
	Database database;

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
    AlertScreen()
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

	void onFirebaseChange() async {
		dynamic dummyDataList=[
			{'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:09:41.927760'},
      {'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:12:56.927608'}, 
			{'latitude': 37.4219983, 'longitude': -122.084, 'datetime': '2020-04-04 18:14:41.927972'}, 
		];
		List<Coordinate> coordList=await DatabaseService().getAllCoordinates(database);
		for(int i=0;i<coordList.length;i++) {
			for(int j=0;j<dummyDataList.length;j++) {
				if(dummyDataList[j]['datetime']==coordList[i].datetime && dummyDataList[i]['latitude']==coordList[i].latitude) {
					print(dummyDataList);
				}
			}
		}
	}

	void _initializePage() async {
		await _listenLocation();
		await _initDatabase();
		//dynamic a=await DatabaseService().getAllCoordinates(database);
		//print(a);
		//timer = Timer.periodic(Duration(seconds: 15), (Timer t) => addNewEntry());
		onFirebaseChange();
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
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
