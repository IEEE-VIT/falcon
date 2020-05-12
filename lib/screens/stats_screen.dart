import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../services/shared.dart';
import '../services/sharedKeys.dart';
import 'new_screen.dart';
import 'stats-pages/android_screen1.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool isIos = Platform.isIOS;

  int _selectedIndexValue = 0;

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
              title: Transform.translate(
                offset: Offset(0.0, -15.0),
                child: Container(
                  child: Text(
                    'Reports',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              bottom: TabBar(
                labelPadding: EdgeInsets.all(0.0),
                indicatorColor: Color(0xFFFA6400),
                labelColor: Color(0xFFFA6400),
                tabs: <Widget>[
                  Tab(
                    key: SharedKeys.statsKeyButton1,
                    text: "Statistics",
                  ),
                  Tab(
                    key: SharedKeys.statsKeyButton2,
                    text: "News",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                AndroidFirstPage(),
                NewsScreen(),
              ],
            )),
      ));
    }
  }

  void initState() {
    super.initState();
    SharedKeys.initStatsTargets();
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }
}
