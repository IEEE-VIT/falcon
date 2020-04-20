import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';

import '../services/shared.dart';
//import '../widgets/snackBar.dart';
import 'home_screen.dart';

class WarningScreen extends StatefulWidget {
  @override
  _WarningScreenState createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  List<dynamic> matchedcoords, finalLocations = [];

  bool _busy=false;

  List<String> place = [
    "Truffles Cafe",
    "Christ college",
    "Starbucks BTM",
    "Lalbagh Botanic Garden",
    "PVR Phoenix"
  ];

  List<String> location = [
    "Mavalli, Benguluru, Karnataka, 560004",
    "Mavalli, Benguluru, Karnataka, 560004",
    "Mavalli, Benguluru, Karnataka, 560004",
    "Mavalli, Benguluru, Karnataka, 560004",
    "Mavalli, Benguluru, Karnataka, 560004"
  ];

  List<String> closeContact = [
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final fgsIsRunning =
              await ForegroundService.foregroundServiceIsStarted();
          if (fgsIsRunning) {
            await ForegroundService.stopForegroundService();
            print('Foreground process stopped');
          } else {
            maybeStartFGS();
            print('Foreground process started!');
          }
        },
        child: Tooltip(
            showDuration: Duration(),
            message: 'Stop Collecting Location Data',
            child: Icon(Icons.stop)),
        backgroundColor: Colors.red,
      ),
      body: 
      _busy
      ?
      Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
      :
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Warnings',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              child: finalLocations.length == 0
                  ? GestureDetector(
                      onLongPress: () async {
                        final fgsIsRunning = await ForegroundService
                            .foregroundServiceIsStarted();
                        if (fgsIsRunning) {
                          await ForegroundService.stopForegroundService();
                        } else {
                          print('Process is not running');
                        }
                      },
                      child: Container(
                        child: Center(
                          child: Text('No warnings to be shown!'),
                        ),
                      ))
                  : ListView.builder(
                      itemCount: finalLocations.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {
                            final fgsIsRunning = await ForegroundService
                                .foregroundServiceIsStarted();
                            if (fgsIsRunning) {
                              await ForegroundService.stopForegroundService();
                            } else {
                              print('Process is not running');
                            }
                          },
                          child: Container(
                            height: 100.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    finalLocations[index]['address'],
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    finalLocations[index]['datetime']
                                        .substring(0, 19),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    closeContact[index],
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAddress(latitude, longitude) async {
    //  final coordinates = new Coordinates(latitude, longitude);
    // //  dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //  dynamic first = addresses.first;
    //  //print("${first.featureName} : ${first.addressLine}");
    //  return first.addressLine;
    List<Placemark> addresses =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    Placemark first = addresses.first;
   // print(addresses);
   // print(addresses.first.name);
   // print(addresses.first.subThoroughfare);
   // print(addresses.first.administrativeArea);
   // print(addresses.first.subAdministrativeArea);
   // print(first.subLocality);
   // print(first.subThoroughfare);
   // print('${first.thoroughfare} : ${first.locality}');
    return first.thoroughfare+', '+first.locality+', '+first.administrativeArea+', '+first.subAdministrativeArea;
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() async {
    _busy=true;
    matchedcoords = await Shared.getMatchedCoordinates();
    print(matchedcoords.length);
    dynamic lastcoords;
    if (matchedcoords.length == 0) {
      setState(() {
        _busy=false;
      });
      return;
    }
    String address = await getAddress(
        matchedcoords[0]['latitude'], matchedcoords[0]['longitude']);
    finalLocations.add({
      'address': address,
      'datetime': matchedcoords[0]['datetime'],
      'latitude': matchedcoords[0]['latitude'],
      'longitude': matchedcoords[0]['longitude']
    });
    for (int i = 0; i < matchedcoords.length; i++) {
      address = await getAddress(
          matchedcoords[i]['latitude'], matchedcoords[i]['longitude']);
      lastcoords = matchedcoords[i];
      lastcoords['address'] = address;
      if ((address == lastcoords['address']) ||
          (matchedcoords[i]['latitude'] == lastcoords['latitude'] &&
              matchedcoords[i]['longitude'] == lastcoords['longitude'])) {
        continue;
      }
      finalLocations.add({
        'address': address,
        'datetime': matchedcoords[i]['datetime'],
        'longitude': matchedcoords[i]['longitude'],
        'latitude': matchedcoords[i]['latitude']
      });
    }
    setState(() {
      _busy=false;
    });
  }
}
