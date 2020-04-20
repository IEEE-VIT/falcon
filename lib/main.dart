import 'package:falcon_corona_app/screens/aok_screen.dart';
import 'package:falcon_corona_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';

import 'screens/begin_screen.dart';
import 'screens/in_quarantine_screen.dart';
import 'screens/start_screen.dart';
import 'screens/temperature_screen.dart';
import 'services/shared.dart';

void main() {
  runApp(MyApp());
  maybeStartFGS();
}

void maybeStartFGS() async {
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(5);
    print('Starting FGS');
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

void foregroundServiceFunction() async {
  print('wassa');
  print('lol');
  print('yy');
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print('xxxxx');
  print("The current location is: ${position.latitude}, ${position.longitude}");
  addNewEntry(position.latitude, position.longitude);
  ForegroundService.notification.setText("The time was: ${DateTime.now()}");
}
class MyApp extends StatefulWidget {

	@override
	_MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp> {

  void loc ()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
  }
	
	@override
	void initState(){
		super.initState();
		Shared.initShared();
    loc();
    // DatabaseService.initDatabase();
	}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Falcon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => StartScreen(),
        '/begin':(context) => BeginScreen(),
        '/temperature':(context) => TemperatureScreen(),
        '/inquarantine':(context) => InQuarantineScreen(),
        '/warning':(context) => HomeScreen(),
        '/aok':(context) => AOKScreen()
      },
      );
  }
}

