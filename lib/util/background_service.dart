import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_utils/utils/spherical_utils.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';


import '../models/circle_adapter.dart';
import 'notification_service.dart';


class BackgroundService{

  Future<bool> isRunning() {
    return BackgroundLocator.isServiceRunning();
  }

  @pragma('vm:entry-point')
  static void callback(LocationDto location) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    if (!Hive.isAdapterRegistered(CircleAdapterAdapter().typeId)) {
      Hive.registerAdapter(CircleAdapterAdapter());
    }

    var box = await Hive.openBox("markerBox");
    await box.close();

    if (kDebugMode) {
      print("background callback ran");
    }

    Box markerBox = await Hive.openBox("markerBox");

    List<String> keysToBeDeleted = [];

    if (kDebugMode) {
      print(markerBox.keys);
    }

    for (var key in markerBox.keys) {
      var val = markerBox.get(key);
      double radius = val.radius;

      double distance = SphericalUtils.computeDistanceBetween(
          Point(location.latitude,
              location.longitude),
          Point(val.latitude,
              val.longtitude));
      if (distance <= radius) {
        notificationService.notify(
            'You are here!', '${val.title} is reached.');
        keysToBeDeleted.add(key);
      }
    }
    for (var key in keysToBeDeleted) {
      markerBox.delete(key);
    }
  }

  @pragma('vm:entry-point')
  static void initCallback(dynamic _) {
    if (kDebugMode) {
      print('Plugin initialization');
    }
  }

  @pragma('vm:entry-point')
  static void notificationCallback() {
    if (kDebugMode) {
      print('User clicked on the notification');
    }
  }

  Future<void> init () async {
    await BackgroundLocator.initialize();
    Map<String, dynamic> data = {'countInit': 1};
    return BackgroundLocator.registerLocationUpdate(callback,
        initDataCallback: data,
        initCallback: initCallback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,/*
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Background location tracking',
                notificationTitle: 'RemindIF',
                notificationMsg: 'RemindIF is running in the background',
                notificationBigMsg:
                'RemindIF is tracking location in the background. This is required for main features to work properly when the app is not running.',
                notificationIcon: "@mipmap/ic_launcher",
                notificationTapCallback:
                notificationCallback))*/);
  }
}
