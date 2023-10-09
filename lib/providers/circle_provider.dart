import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:remindif/models/circle_adapter.dart';
import 'package:remindif/models/circle_item.dart';

import '../widgets/circle_dialog.dart';

class CircleProvider extends ChangeNotifier {
  late Box markerBox;
  Map<CircleId, CircleItem>? _circleItems;
  final Set<Circle> _circles = {};

  Map<CircleId, CircleItem>? get circleItems => _circleItems;

  Set<Circle> get circles => _circles;

  init(BuildContext context) async {
    if (!Hive.isBoxOpen("markerBox")) {
      markerBox = await Hive.openBox("markerBox");
    } else {
      markerBox = Hive.box("markerBox");
    }
    if (kDebugMode) {
      print("constructor ran");
    }
    _circleItems = Map.from(markerBox.toMap().map((key, value) {
      return MapEntry(
          CircleId(key),
          CircleItem(
              title: value.title,
              circle: Circle(
                  circleId: CircleId(key),
                  center: LatLng(value.latitude, value.longtitude),
                  radius: value.radius,
                  fillColor: Colors.blueAccent.withOpacity(0.5),
                  strokeWidth: 3,
                  strokeColor: Colors.blueAccent,
                  consumeTapEvents: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return CircleDialog(
                            circleId: CircleId(key),
                          );
                        },
                      ),
                    );
                  })));
    }));

    var values = circleItems?.values;
    for (var circleItem in values!) {
      _circles.add(circleItem.circle);
    }

    notifyListeners();
  }

  CircleItem? getCircleItem(CircleId circleId) {
    return circleItems![circleId];
  }

  void addCircle(Circle circle, String title, double radius) {
    CircleItem circleItem =
        CircleItem(title: title, circle: circle);
    CircleAdapter circleAdapter = CircleAdapter(
        title: title,
        latitude: circle.center.latitude,
        longtitude: circle.center.longitude,
        radius: radius);
    circleItems![circle.circleId] = circleItem;
    _circles.add(circle);
    markerBox.put(circle.circleId.value.toString(), circleAdapter);
    notifyListeners();
  }

  void removeCircle(CircleId circleId) {
    CircleItem? circleItem = circleItems![circleId];
    Circle? circle = circleItem?.circle;
    circleItems?.remove(circleId);
    circles.remove(circle);
    markerBox.delete(circleId.value.toString());
    notifyListeners();
  }
}
