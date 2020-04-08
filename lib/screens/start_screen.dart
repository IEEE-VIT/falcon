import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/falcon_logo.png'),
            ),
            SizedBox(
              height: 60.0,
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
                  Navigator.pushNamed(context, '/warning');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
