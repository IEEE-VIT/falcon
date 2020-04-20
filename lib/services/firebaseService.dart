import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/coordinate.dart';
import 'databaseService.dart';
import 'shared.dart';

DatabaseReference DBRef;
Database database;
dynamic uuid;

class FirebaseService {

  static initFirebaseService() {
    final DatabaseReference dbref = FirebaseDatabase.instance.reference();
    DBRef=dbref;
    uuid=Uuid();
  }

  static void setUpListener() {
    final childRef =
        DBRef.child('users').onChildAdded.listen(onChangeDetection);
    // final childRef=DBRef.onChildChanged.listen(_onChageDetection);
    print(childRef);
    print("Listener Set!");
  }

  static void onChangeDetection(Event event) {
    //print(event.snapshot);
    print("Change detected!");
    print(event.snapshot.value);
    print(event.snapshot);
    onFirebaseChange(event.snapshot.value);
  }

  static void onFirebaseChange(dynamic dummyDataList) async {
    print('inFirebaseChange');
    dynamic matchedCoords = [];
    database = await DatabaseService().initDatabase();
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
    print(matchedCoords);
    Shared.setMatchedCoordinates(matchedCoords);
    print('Stored Locally!');
  
  }
  static Future<void> uploadDataToFirebase() async {
    print(DBRef.child('users').key);
    print(DBRef.child('users').path);
    Database database=await DatabaseService().initDatabase();
   // if(Shared.isCaseReported()) {
   //   return;
   // }
    // dynamic coordinates=await DatabaseService().getAllRawCoordinates(widget.database);
    dynamic coordinates=await DatabaseService().getAllRawCoordinates(database);
    dynamic a=List.generate(coordinates.length, (i) {
			return <dynamic, dynamic>{
        'latitude': coordinates[i]['latitude'],
        'longitude': coordinates[i]['longitude'],
        'datetime': coordinates[i]['datetime'],
      };
		});
    DBRef.child("users").child(Shared.getUuid())
    //DBRef.child("users").child(uuid.v4())
    .set(a);
    return Future.value();
  }
}
