import 'package:flutter/material.dart';

class BeginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/doctor-woman.png'),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text(
            'To help FALCON work better we like some information from you. Please enter the necessary information in the next steps.',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 60.0,
          ),
          SizedBox(
            width: 281.0,
            height: 49.0,
            child: RaisedButton(
              child: Text(
                'Begin',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0
                ),
              ),
              color: Color(0xFFFA6400),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/temperature');
              },
            ),
          ),
          FlatButton(
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.black38),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
