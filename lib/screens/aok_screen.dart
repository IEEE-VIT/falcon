import 'package:flutter/material.dart';
import '../services/shared.dart';

class AOKScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget appBar=Shared.isCaseReported()
        ?
        AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          elevation:  0.0,
        )
        :
        AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottomOpacity: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFFFA6400),
            ),
            onPressed:() => Navigator.of(context).pop(),
          ),
        );
    return Scaffold(
      appBar: appBar,
      //AppBar(
      //  elevation: 0.0,
      //  backgroundColor: Colors.white,
      //  bottomOpacity: 0,
      //  leading: IconButton(
      //    icon: Icon(
      //      Icons.arrow_back,
      //      color: Color(0xFFFA6400),
      //    ),
      //    onPressed:() => Navigator.of(context).pop(),
      //  ),
      //),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 120,
              width: 160,
              child: Image(
                image: AssetImage('images/handVector.png'),
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text(
            'You will be A-Ok!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Your Report will help us prevent',
            style: TextStyle(fontSize: 16.0, color: Colors.black45),
          ),
          Text(
            'Covid-19 from communal spreading.',
            style: TextStyle(fontSize: 16.0, color: Colors.black45),
          ),
          Text(
            'Please make sure you visit the nearest',
            style: TextStyle(fontSize: 16.0, color: Colors.black45),
          ),
          Text(
            'Hospital for treatment.',
            style: TextStyle(fontSize: 16.0, color: Colors.black45),
          ),
          SizedBox(
            height: 34.0,
          ),
          Text(
            'Get Well Soon',
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF32B74D)),
          ),
        ],
      ),
    );
  }
}
