import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../services/shared.dart';
import 'new_screen.dart';
import 'stats-pages/android_screen1.dart';


class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool isIos = Platform.isIOS;

  int _selectedIndexValue = 0;

  List<TargetFocus> targets = List();

  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (isIos) {
      return CupertinoApp(
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('IOS'),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(top: 10),
                    children: <Widget>[
                      CupertinoSegmentedControl(
                        children: {
                          0: Text("Statistics"),
                          1: Text("News"),
                        },
                        selectedColor: Color(0xFFFA6400),
                        groupValue: _selectedIndexValue,
                        onValueChanged: (value) {
                          setState(() => _selectedIndexValue = value);
                        },
                      ),

                      _selectedIndexValue == 0
                          ? AndroidFirstPage()
                          : NewsScreen()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
          home: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Text(
                    'Reports',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: Color(0xFFFA6400),
                    labelColor: Color(0xFFFA6400),
                    tabs: <Widget>[
                      Tab(
                        key: keyButton1,
                        text: "Statistics",

                      ),
                      Tab(
                        key: keyButton2,
                        text: "News",
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[AndroidFirstPage(), NewsScreen()],
                )),
          ));
    }
  }


  void initState() {
    super.initState();
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: keyButton1,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Get the latest statistics",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: keyButton2,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Get the latest news",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, finish: () {
    }, clickTarget: (target) {
    }, clickSkip: () {
    })
      ..show();
  }

  void _afterLayout(_) {
    if (Shared.showStatsTutorial()) {
      Future.delayed(Duration(milliseconds: 100), () {
        showTutorial();
      });
    }
  }
}
