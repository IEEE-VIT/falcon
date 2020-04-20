import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

SharedPreferences prefs;
bool caseReported;

class Shared {
	
	static Future<void> initShared() async {
  	prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('caseReported')) 
     {
       prefs.setBool('caseReported', false);
       caseReported=false;
     } 
    if(!prefs.containsKey('uuid')) {
      var uuid = new Uuid();
      String uUID=uuid.v4();
      prefs.setString('uuid', uUID);
      print('First Time enter');
      print('UUID:$uUID');
    }
    else {
      caseReported=prefs.getBool('caseReported');
    }
    print('Database Initialized!');
		return Future.value();
	}

	static Future<void> setMatchedCoordinates(dynamic coords) async {
    List<dynamic> previousMatchedCoords=await getMatchedCoordinates();
    if(previousMatchedCoords==null) {
      previousMatchedCoords=[];
    }
   List<dynamic> newList;
   if(previousMatchedCoords.isNotEmpty && coords.isNotEmpty) {
     newList=[...previousMatchedCoords, ...coords];
   }
   if(previousMatchedCoords.isEmpty && coords.isEmpty) {
     newList=[];
   }
   if(previousMatchedCoords.isEmpty) {
     newList=[...coords];
   }
   if(coords.isEmpty) {
     newList=[...previousMatchedCoords];
   }
		return prefs.setString('matchedCoords', json.encode(newList));
	}
	
	static Future<dynamic> getMatchedCoordinates() async {
    if(!prefs.containsKey('matchedCoords')) {
      print('No coordinates stored!');
      return Future.value([]);
    }
		return Future.value(json.decode(prefs.getString('matchedCoords')));
    //return Future.value();
	}

  static Future<bool> setCaseReported() async {
    caseReported=true;
    print('AOK-Set');
    return prefs.setBool('caseReported', true);
  }

  static isCaseReported() {
    return caseReported;
  }

  static getUuid() {
    return prefs.getString('uuid');
  }

  static storeAffectedCities() {
  }
}
