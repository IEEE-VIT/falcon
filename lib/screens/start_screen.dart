import 'package:flutter/material.dart';
import '../services/shared.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
//class StartScreen extends StatelessWidget {
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() async {
    Future.delayed(Duration(milliseconds: 1000), () {
      Shared.showIntro()
          ? Navigator.pushReplacementNamed(context, '/onBoarding')
          : Navigator.pushReplacementNamed(context, '/warning');
    });
  }

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
              width: 36.0,
              height: 36.0,
              child: 
              CircularProgressIndicator(),
            //  RaisedButton(
            //    child: Text(
            //      'Continue',
            //      style: TextStyle(fontSize: 18.0),
            //    ),
            //    color: Colors.black45,
            //    textColor: Colors.white,
            //    shape: RoundedRectangleBorder(
            //      borderRadius: BorderRadius.circular(10.0),
            //    ),
            //    onPressed: () {
            //      //Navigator.pushNamed(context, '/begin');
            //      Shared.showIntro()
            //          ? Navigator.pushReplacementNamed(context, '/onBoarding')
            //          : Navigator.pushReplacementNamed(context, '/warning');
            //    },
            //  ),
            ),
          ],
        ),
      ),
    );
  }
}
