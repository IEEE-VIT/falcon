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
		return prefs.setString('matchedCoords', coords);
	}
	
	static Future<dynamic> getMatchedCoordinates() async {
		return Future.value(json.decode(prefs.getString('matchedCoords')));
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
}
