import 'package:falcon_corona_app/models/district_cases.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/shared.dart';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Marker> allMarkers = [];
  List<LatLng> polygonCoords = List();
  Set<Polygon> polygonSet = new Set();
  Set<Circle> circles = Set();
  dynamic matchedcoords;
  final coords = [];
  LatLng initialPosition;

  GoogleMapController _controller;

    Future<List<DistrictCases>> getDistrictCases() async{
    final response = await http.get(
      "https://api.covid19india.org/v2/state_district_wise.json"
    );

    final cases = districtCasesFromJson(response.body);
    return cases;
  } 

  void _addCircles() async{
    final casesData = await getDistrictCases();
    for(int i = 0; i<casesData.length; i++){
      for(int j=0; j<casesData[i].districtData.length; j++){
        if(casesData[i].districtData[j].district == "Unknown"){
          continue;
        } try {
          print(casesData[i].districtData[j].district);
          final addresses = await Geolocator().placemarkFromAddress(casesData[i].districtData[j].district);
          var lat = addresses.first.position.latitude;
          var long = addresses.first.position.longitude;
          final latlng = LatLng(lat, long);
          coords.add([latlng, casesData[i].districtData[j].confirmed]);
        } on Exception{
          continue;
        }
      }
    }
    setState(() { 
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

  void _initializePage() async {

    //final SharedPreferences prefs = await _prefs;

    Position currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    setState(() {
      initialPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      print(currentLocation.longitude);
    });
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

  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _initializePage();
    _addCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(21.000, 72.00), zoom: 2.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
            circles: circles,
          ),
        ),
    );
  }

  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }
}

