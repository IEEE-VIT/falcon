import 'package:flutter/material.dart';

class TemperatureScreen extends StatefulWidget {
  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  int temp = 39;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'What is your Temperature',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: 80.0,
          ),
          Text(
            '$temp°C',
            style: TextStyle(
              color: Color(0xFFFA6400),
              fontSize: 28.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTrackColor: Colors.white,
              activeTrackColor: Color(0xFFFA6400),
              thumbColor: Color(0xFFFA6400),
              overlayColor: Color(0x29EB1555),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
            ),
            child: Slider(
              value: temp.toDouble(),
              min: 34.0,
              max: 44.0,
              onChanged: (double newValue) {
                setState(() {
                  temp = newValue.round();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '34°C',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0
                  ),
                ),
                Text(
                  '44°C',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 70.0,
          ),
          SizedBox(
            width: 281.0,
            height: 55.0,
            child: RaisedButton(
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              color: Colors.black45,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/inquarantine');
              },
            ),
          ),
        ],
      ),
    );
  }
}
