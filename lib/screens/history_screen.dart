import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Marker> allMarkers = [];
  List<LatLng> polygonCoords = List();
  Set<Polygon> polygonSet = new Set();

  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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