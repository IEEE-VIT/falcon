import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
//import '../services/FGS.dart';

// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import '../services/databaseService.dart';
import '../models/coordinate.dart';

// final Location location = Location();
// LocationData _location;
// StreamSubscription<LocationData> _locationSubscription;
// String _error;



//use an async method so we can await
void maybeStartFGS() async {
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

//Future<void> addNewEntry() {
//  Coordinate coordinate=Coordinate(
//      latitude: _location.latitude,
//      longitude: _location.longitude,
//      datetime: DateTime.now().toString()
//  );
//  print(coordinate.toJson());
//  DatabaseService().insertCoordinate(database, coordinate);	
//  return Future.value();
//}

void foregroundServiceFunction() async {
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  debugPrint("The current location is: $position");
  ForegroundService.notification.setText("The time was: ${DateTime.now()}");
}


class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  String _appMessage = "";

  @override
  void initState() {
    super.initState();
  }

  //Future<void> _listenLocation() async {
  //  _locationSubscription =
  //      location.onLocationChanged.handleError((dynamic err) {
  //    _locationSubscription.cancel();
  //  }).listen((LocationData currentLocation) {
  //    setState(() {
  //      _location = currentLocation;
  //    });
  //  });
  //}


  void _toggleForegroundServiceOnOff() async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();
    String appMessage;

    if (fgsIsRunning) {
      await ForegroundService.stopForegroundService();
      appMessage = "Stopped foreground service.";
    } else {
      maybeStartFGS();
      appMessage = "Started foreground service.";
    }

    setState(() {
      _appMessage = appMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text('Foreground Service Example',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.all(8.0)),
            Text(_appMessage, style: TextStyle(fontStyle: FontStyle.italic))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )),
        floatingActionButton: Column(
          children: <Widget>[
            FloatingActionButton(
              child: Text("F"),
              onPressed: _toggleForegroundServiceOnOff,
              tooltip: "Toggle Foreground Service On/Off",
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
