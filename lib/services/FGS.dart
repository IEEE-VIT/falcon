//import 'dart:async';
//
//import 'package:foreground_service/foreground_service.dart';
//import 'package:flutter/material.dart';
//import 'package:location/location.dart';
//
//final Location location = Location();
//LocationData _location;
//StreamSubscription<LocationData> _locationSubscription;
//String _error;
//
//
////Future<void> _listenLocation() async {
////  _locationSubscription =
////      location.onLocationChanged.handleError((dynamic err) {
////    _locationSubscription.cancel();
////  }).listen((LocationData currentLocation) {
////    setState(() {
////      _location = currentLocation;
////    });
////  });
////}
//
////use an async method so we can await
//void maybeStartFGS() async {
//  if (!(await ForegroundService.foregroundServiceIsStarted())) {
//    await ForegroundService.setServiceIntervalSeconds(5); 
//    //necessity of editMode is dubious (see function comments)
//    await ForegroundService.notification.startEditMode();
//
//    await ForegroundService.notification
//        .setTitle("Example Title: ${DateTime.now()}");
//    await ForegroundService.notification
//        .setText("Example Text: ${DateTime.now()}");
//
//    await ForegroundService.notification.finishEditMode();
//
//    await ForegroundService.startForegroundService(foregroundServiceFunction);
//    await ForegroundService.getWakeLock();
//  }
//}
//
//void foregroundServiceFunction() {
//  debugPrint("The current time is: ${DateTime.now()}");
//  ForegroundService.notification.setText("The time was: ${DateTime.now()}");
//}
//
