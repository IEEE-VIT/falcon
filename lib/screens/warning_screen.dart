
import 'package:flutter/material.dart';

class WarningScreen extends StatefulWidget {
  @override
  _WarningScreenState createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
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
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.w900
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: location.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            place[index],
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Text(
                            location[index],
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400
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
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

