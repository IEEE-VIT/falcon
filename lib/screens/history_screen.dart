import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    getDistrictCases().then((casesData) async{
      for(int i = 0; i<casesData.length; i++){
        for(int j=0; j<casesData[i].districtData.length; j++){
          if(casesData[i].districtData[j].district == "Unknown"){
            continue;
          } try{
            final addresses = await Geocoder.local.findAddressesFromQuery(casesData[i].districtData[j].district);
            var lat = addresses.first.coordinates.latitude;
            var long = addresses.first.coordinates.longitude;
            final latlng = LatLng(lat, long);
            coords.add([latlng, casesData[i].districtData[j].confirmed]);
          } on PlatformException{
            continue;
          }
        }
      }
    });
    setState(() { 
      _controller = controller;
      for(int k = 0; k<coords.length; k++){
        double radius = 0;
        int color = 0;
        if(coords[k][1]<50){
          radius = 25;
          color = 300;
        } else if(coords[k][1]<100){
          radius = 50;
          color = 400;
        } else if(coords[k][1]<200){
          radius = 100;
          color = 500;
        } else if(coords[k][1]<300){
          radius = 200;
          color = 600;
        } else if(coords[k][1]<500){
          radius = 300;
          color = 700;
        } else {
          radius = 500;
          color = 900;
        }
        circles.add(
          Circle(
            circleId: CircleId(coords[k][1].toString()),
            center: coords[k][0],
            radius: radius,
            strokeColor: Colors.red,
            strokeWidth: 5,
            fillColor: Colors.red[color]
          )
        );
      }
      print(circles);
    });
  }
}
