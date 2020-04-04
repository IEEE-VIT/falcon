import 'package:flutter/material.dart';

class AOKScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 20,
              width: 20,
              child: Image(
                image: AssetImage(
                    'images/handVector.png'
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text(
            'You will be A-Ok!',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Your Report will help us prevent',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45
            ),
          ),
          Text(
            'Covid-19 from communal spreading.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45
            ),
          ),
          Text(
            'Please make sure you visit the nearest',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45
            ),
          ),
          Text(
            'Hospital for treatment.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45
            ),
          ),
          SizedBox(
            height: 34.0,
          ),
          Text(
            'Get Well Soon',
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF32B74D)
            ),
          ),
        ],
      ),
    );
  }
}
