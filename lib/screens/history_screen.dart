import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import '../services/shared.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Marker> allMarkers = [];
  List<LatLng> polygonCoords = List();
  Set<Polygon> polygonSet = new Set();
  dynamic matchedcoords;

  GoogleMapController _controller;

  void _initializePage() async {

    //final SharedPreferences prefs = await _prefs;

    //dynamic matchedCoords=json.decode(prefs.getString('matchedCoords'));
    dynamic matchedCoords=await Shared.getMatchedCoordinates();
    matchedcoords=matchedCoords;

    // final coordinates = new Coordinates(matchedCoords[0]['latitude'], matchedCoords[0]['longitude']);
    // dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // dynamic first = addresses.first;
    // print("${first.featureName} : ${first.addressLine}");

    for(int i=0;i<matchedCoords.length;i++) {
      // final coordinates = new Coordinates(matchedCoords[i]['latitude'], matchedCoords[i]['longitude']);
      // dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // dynamic first = addresses.first;
      // print("${first.featureName} : ${first.addressLine}");
      allMarkers.add(Marker(
          markerId: MarkerId(matchedCoords[i]['datetime']??'something'),
          draggable: true,
          onTap: () {
           print('Marker Tapped');
          },
          position: LatLng(matchedCoords[i]['latitude'], matchedCoords[i]['longitude']),
          infoWindow: InfoWindow(
            // title: first.featureName,
            // snippet: first.addressLine,
            title: 'Something',
            snippet: 'Anything',
          ),
        )
      );
    }

    print(allMarkers);

    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(41.7128, -74.0060)));

    allMarkers.add(Marker(
        markerId: MarkerId('sup'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(40.7128, -74.0060)));
          polygonCoords.add(LatLng(41.7128, -74.0060));
          polygonCoords.add(LatLng(42.7128, -74.0060));
          polygonCoords.add(LatLng(40.7128, -71.0060));
          polygonCoords.add(LatLng(40.7128, -75.0060));
    polygonSet.add(Polygon(
      polygonId: PolygonId('test'),
      points: polygonCoords,
      strokeColor: Colors.red,
      strokeWidth: 5,
      fillColor: Colors.red[200])
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
            polygons: polygonSet,
          ),
        ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
