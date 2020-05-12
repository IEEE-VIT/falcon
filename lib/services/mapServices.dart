import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/district_cases.dart';
import '../widgets/snackBar.dart';
import 'shared.dart';

class MapService {
  static Future<Set<Circle>> buildMapCircles({BuildContext context}) async {
    Set<Circle> circles = Set();
    final List<dynamic> coords = [];
    final List<Map<String, dynamic>> coordsMap=[];
    final casesData = await getDistrictCases();
    for (int i = 0; i < casesData.length; i++) {
      for (int j = 0; j < casesData[i].districtData.length; j++) {
        if (casesData[i].districtData[j].district == "Unknown") {
          continue;
        }
        try {
          //print(casesData[i].districtData[j].district);
          final addresses = await Geolocator()
              .placemarkFromAddress(casesData[i].districtData[j].district);
          var lat = addresses.first.position.latitude;
          var long = addresses.first.position.longitude;
          final latlng = LatLng(lat, long);
          coords.add([latlng, casesData[i].districtData[j].confirmed]);
          coordsMap.add({
            'latitude': lat,
            'longitude': long,
            'confirmed': casesData[i].districtData[j].confirmed
          });
        } on Exception {
          continue;
        }
      }
      if(i==5) {
        break;
      }
    }
   // for (int k = 0; k < coords.length; k++) {
   //   double radius = 0;
   //   int color = 0;
   //   if (coords[k][1] < 50) {
   //     radius = 2500;
   //     color = 300;
   //   } else if (coords[k][1] < 100) {
   //     radius = 5000;
   //     color = 400;
   //   } else if (coords[k][1] < 200) {
   //     radius = 10000;
   //     color = 500;
   //   } else if (coords[k][1] < 300) {
   //     radius = 20000;
   //     color = 600;
   //   } else if (coords[k][1] < 500) {
   //     radius = 30000;
   //     color = 700;
   //   } else {
   //     radius = 50000;
   //     color = 900;
   //   }
   //   circles.add(Circle(
   //       circleId: CircleId(coords[k][1].toString()),
   //       center: coords[k][0],
   //       radius: radius,
   //       strokeColor: Colors.red[color],
   //       strokeWidth: 5,
   //       fillColor: Colors.red[color]));
   // }
    Shared.setAffectedCitiesCircles(coordsMap);
    circles=Shared.getAffectedCitiesCircles();
    Shared.setLastUpdatedStamp(DateTime.now());
    if(context!=null) {
      showSnackbar(
        context: context,
        content: 'Last Updated at ${Shared.getLastUpdatedStamp()['date']} at ${Shared.getLastUpdatedStamp()['time']}',
        label: 'Refresh',
        labelPressAction: () async {
          print('Update all locations again!');
          circles=await MapService.buildMapCircles(context: context);
        });
    }
    return Future.value(circles);
  }

  static Future<List<Marker>> buildMarkers() async {
    List<Marker> allMarkers=[];
    dynamic matchedCoords = await Shared.getMatchedCoordinates();

    // final coordinates = new Coordinates(matchedCoords[0]['latitude'], matchedCoords[0]['longitude']);
    // dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // dynamic first = addresses.first;
    // print("${first.featureName} : ${first.addressLine}");

    for (int i = 0; i < matchedCoords.length; i++) {
      // final coordinates = new Coordinates(matchedCoords[i]['latitude'], matchedCoords[i]['longitude']);
      // dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // dynamic first = addresses.first;
      // print("${first.featureName} : ${first.addressLine}");
      allMarkers.add(Marker(
        markerId: MarkerId(matchedCoords[i]['datetime'] ?? 'something'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position:
            LatLng(matchedCoords[i]['latitude'], matchedCoords[i]['longitude']),
        infoWindow: InfoWindow(
          // title: first.featureName,
          // snippet: first.addressLine,
          title: 'Something',
          snippet: 'Anything',
        ),
      ));
    }
    return Future.value(allMarkers);
  }

  static Future<List<DistrictCases>> getDistrictCases() async {
    final response = await http
        .get("https://api.covid19india.org/v2/state_district_wise.json");

    final cases = districtCasesFromJson(response.body);
    return cases;
  }
}
