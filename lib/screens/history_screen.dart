import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryScreen extends StatefulWidget {

  double lattitude = 22.5448;
  double longitude = 88.3426;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
  GoogleMapController mapController;

  final Map<String, Marker> markers = {};

  final LatLng _center = LatLng(widget.lattitude, widget.longitude);

  void _onMapCreated(GoogleMapController controller) {

    setState(() {
      final locations = [
        {
          "name": MarkerId("something"),
          "lat": 22.19,
          "lng": 88.54
        },
        {
          "name": MarkerId("sup"),
          "lat": 23.29,
          "lng": 88.54
        },
        {
          "name": MarkerId("now"),
          "lat": 22.19,
          "lng": 89.94
        }
      ];
      markers.clear();
      for(final location in locations){
        final marker = Marker(
          markerId: location["name"],
          position: LatLng(location["lat"], location["lng"])
        );
      markers[location["name"]] = marker;
      }
    });
  }
    return Scaffold(
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markers.values.toSet(),
        ),
    );
  }
}