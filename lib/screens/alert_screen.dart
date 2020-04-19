import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';

import 'package:falcon_corona_app/services/databaseService.dart';
import '../services/shared.dart';

class AlertScreen extends StatefulWidget {

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {

  Database database;

  var childRef;
  final DBRef=FirebaseDatabase.instance.reference();

  Future<void> uploadDataToFirebase() async {
    Database database=await DatabaseService().initDatabase();
    if(Shared.isCaseReported()) {
      return;
    }
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
    .set(a);
    return Future.value();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 120,
              width: 160,
              child: Image(
                image: AssetImage(
                  'images/doctor-man.png'
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text(
            'No Case Reported',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'None of your locations will be sent to',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Text(
            'the internet until you report a case.',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          SizedBox(
            width: 281.0,
            height: 49.0,
            child: RaisedButton(
              child: Text(
                'Report Case',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.0
                ),
              ),
              color: Color(0xFFFA6400),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: 
              Shared.isCaseReported()
              ?
              null
              :
              () async {
                await uploadDataToFirebase();
                Shared.setCaseReported();
                Navigator.pushNamed(context, '/aok');
              },
            ),
          ),
        ],
      ),
    );
  }
}
