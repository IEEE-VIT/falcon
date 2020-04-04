
import 'dart:async';

import 'package:falcon_corona_app/screens/alert_screen.dart';
import 'package:falcon_corona_app/screens/aok_screen.dart';
import 'package:falcon_corona_app/screens/start_screen.dart';
import 'package:falcon_corona_app/screens/warning_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Location location = Location();

  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      setState(() {
        _error = null;

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
    AOKScreen(),
    AlertScreen()
  ];

  @override
  void initState() {
    _listenLocation();
    super.initState();
  }

  @override
  void dispose() {
    _stopListen();
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