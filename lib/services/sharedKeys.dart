import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SharedKeys {
  static GlobalKey keyButton = GlobalKey();
  static GlobalKey keyButton1 = GlobalKey();
  static GlobalKey keyButton2 = GlobalKey();
  static GlobalKey keyButton3 = GlobalKey();
  static GlobalKey keyButton4 = GlobalKey();
  static GlobalKey keyButton5 = GlobalKey();
  static GlobalKey statsKeyButton1 = GlobalKey();
  static GlobalKey statsKeyButton2 = GlobalKey();
  static GlobalKey warningKeyButton1 = GlobalKey();
  static GlobalKey reportKeyButton1 = GlobalKey();
  static GlobalKey mapKeyButton1 = GlobalKey();

  static List<TargetFocus> homeTargets = List();
  static List<TargetFocus> statsTargets = List();
  static List<TargetFocus> warningTargets = List();
  static List<TargetFocus> reportTargets = List();
  static List<TargetFocus> mapTargets = List();

  static void initHomeTargets() {
  }

  static void initStatsTargets() {
   // statsTargets.add(makeTarget(
   //   key: statsKeyButton1,
   //   align: AlignContent.bottom,
   //   title: 'Get the latest statistics',
   //   desc:
   //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
   //   shapeLightFocus: ShapeLightFocus.RRect,
   // ));
   // statsTargets.add(makeTarget(
   //   key: statsKeyButton2,
   //   align: AlignContent.bottom,
   //   title: 'Get the latest news',
   //   desc:
   //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
   //   shapeLightFocus: ShapeLightFocus.RRect,
   // ));
    statsTargets.add(makeTarget(
      key: keyButton,
      align: AlignContent.top,
      title: 'Gain all round covid updates from trustful sources',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.Circle,
    ));
    statsTargets.add(makeTarget(
      key: keyButton1,
      align: AlignContent.top,
      title: 'Get all necessary warnings and alerts realted to possible encounters',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.Circle,
    ));
    statsTargets.add(makeTarget(
      key: keyButton2,
      align: AlignContent.top,
      title: 'Check data with the help of map',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.Circle,
    ));
    statsTargets.add(makeTarget(
      key: keyButton3,
      align: AlignContent.top,
      title: 'Report your case',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.Circle,
    ));
  }

  static void initWarningTargets() {
    warningTargets.add(makeTarget(
      key: warningKeyButton1,
      align: AlignContent.top,
      title: 'Start/Stop location tracking',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.Circle,
    ));
  }

  static void initMapTargets() {
    mapTargets.add(makeTarget(
      key: mapKeyButton1,
      align: AlignContent.top,
      title: "Refresh map data with the help of this button",
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.RRect,
    ));
  }

  static void initReportTargets() {
    reportTargets.add(makeTarget(
      key: reportKeyButton1,
      align: AlignContent.top,
      title: 'If you are infected, help others by clicking this button!',
      desc:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
      shapeLightFocus: ShapeLightFocus.RRect,
    ));
  }

  static TargetFocus makeTarget(
      {GlobalKey key,
      AlignContent align,
      String title,
      String desc,
      ShapeLightFocus shapeLightFocus,
      }) {
    return (TargetFocus(
      identify: "Target 2",
      keyTarget: key,
      contents: [
        ContentTarget(
            align: align,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      desc,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: shapeLightFocus,
    ));
  }
}
