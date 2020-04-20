import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'stats-pages/android_screen1.dart';
import 'stats-pages/android_screen2.dart';
import 'stats-pages/ios_screen1.dart';
import 'stats-pages/ios_screen2.dart';
import 'new_screen.dart';



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
                        text: "Statistics",

                      ),
                      Tab(
                        text: "News",
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[AndroidFirstPage(), AndroidSecondPage()],
                )),
          ));
    }
  }
}