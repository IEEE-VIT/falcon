import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),
        heroAssetPath: 'images/onBoarding1.png',
        title: Text('',//Hotels
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('Each one of us have the power to help prevent us the spread of Covid-19',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: 'images/onBoarding1.png'),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroAssetPath: 'images/onBoarding2.png',
        title: Text('',//Banks
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'Falcon track, through a location generated social graph, your interaction with someone who could have been tested COVID-19 positive',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: 'images/onBoarding2.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'images/onBoarding3.png',
      title: Text('',//'Store'
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('Simply switch on Bluetooth & Location whenever you step out of the house',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: 'images/onBoarding3.png',
    ),
    PageModel(
      color: const Color(0xFF678FB4),
      heroAssetPath: 'images/onBoarding4.png',
      title: Text('',//Store
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('You will be alerted if someone you have come in close proximity of, even unknowingly, tests COVID-19 positive',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: 'images/onBoarding4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "",
        pageList: pageList,
        onDoneButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/warning'),
        onSkipButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/warning'),
      ),
    );
  }
}
