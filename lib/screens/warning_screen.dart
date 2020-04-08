import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

import '../services/shared.dart';

class WarningScreen extends StatefulWidget {
  @override
  _WarningScreenState createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  
  List<dynamic> matchedcoords, finalLocations=[];

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
    "Close contact with a person infected with Covid-19e",
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19",
    "Close contact with a person infected with Covid-19"
  ];

  Future<String> getAddress(latitude, longitude) async {
     final coordinates = new Coordinates(latitude, longitude);
     dynamic addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     dynamic first = addresses.first;
     //print("${first.featureName} : ${first.addressLine}");
     return first.addressLine;
  }

  void _initializePage() async {
   matchedcoords=await Shared.getMatchedCoordinates();
   print(matchedcoords.length);
   dynamic lastcoords;
   String address=await getAddress(matchedcoords[0]['latitude'], matchedcoords[0]['longitude']);
   finalLocations.add(
     {
       'address': address, 
       'datetime': matchedcoords[0]['datetime'],
       'latitude': matchedcoords[0]['latitude'],
       'longitude': matchedcoords[0]['longitude']
     }
   );
   for(int i=0;i<matchedcoords.length;i++) {
     address=await getAddress(matchedcoords[i]['latitude'], matchedcoords[i]['longitude']);
     lastcoords=matchedcoords[i];
     lastcoords['address']=address;
     if((address==lastcoords['address'])
         || (matchedcoords[i]['latitude']==lastcoords['latitude'] && matchedcoords[i]['longitude']==lastcoords['longitude'])) {
       continue;
     }
     finalLocations.add({
       'address': address, 
       'datetime': matchedcoords[i]['datetime'],
       'longitude': matchedcoords[i]['longitude'],
       'latitude': matchedcoords[i]['latitude']
     });
   }
   //print(lastcoords);
   //print(finalLocations);
   setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              child:
              ListView.builder(
                  itemCount: finalLocations.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Text(
                            //  place[index],
                            //  style: TextStyle(
                            //      fontSize: 17.0, fontWeight: FontWeight.w700),
                            //),
                            Text(
                              finalLocations[index]['address'],
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              finalLocations[index]['datetime'].substring(0, 19),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400
                              ),
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
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
