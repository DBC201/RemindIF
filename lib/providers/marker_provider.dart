import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:remind_if/models/marker_adapter.dart';
import 'package:remind_if/models/marker_item.dart';

import '../widgets/marker_dialog.dart';

class MarkerProvider extends ChangeNotifier {
  late Box markerBox;
  Map<MarkerId, MarkerItem>? _markerItems;
  final Set<Marker> _markers = {};

  Map<MarkerId, MarkerItem>? get markerItems => _markerItems;

  Set<Marker> get markers => _markers;

  initMarkers(BuildContext context) async {
    if (!Hive.isBoxOpen("markerBox")) {
      markerBox = await Hive.openBox("markerBox");
    } else {
      markerBox = Hive.box("markerBox");
    }
    if (kDebugMode) {
      print("constructor ran");
    }
    _markerItems = Map.from(markerBox.toMap().map((key, value) {
      return MapEntry(
          MarkerId(key),
          MarkerItem(
              title: value.title,
              marker: Marker(
                  markerId: MarkerId(key),
                  position: LatLng(value.latitude, value.longtitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return MarkerDialog(
                            markerId: MarkerId(key),
                          );
                        },
                      ),
                    );
                  }),
              meterProximity: value.meterProximity));
    }));

    var values = _markerItems?.values;
    for (var markerItem in values!) {
      _markers.add(markerItem.marker);
    }

    notifyListeners();
  }

  MarkerItem? getMarkerItem(MarkerId markerId) {
    return _markerItems![markerId];
  }

  void addMarker(Marker marker, String title, int proximity) {
    MarkerItem markerItem =
        MarkerItem(title: title, marker: marker, meterProximity: proximity);
    MarkerAdapter markerAdapter = MarkerAdapter(
        title: title,
        latitude: marker.position.latitude,
        longtitude: marker.position.longitude,
        meterProximity: proximity);
    _markerItems![marker.markerId] = markerItem;
    _markers.add(marker);
    markerBox.put(marker.markerId.value.toString(), markerAdapter);
    notifyListeners();
  }

  void removeMarker(MarkerId markerId) {
    MarkerItem? markerItem = _markerItems![markerId];
    Marker? marker = markerItem?.marker;
    _markerItems?.remove(markerId);
    markers.remove(marker);
    markerBox.delete(markerId.value.toString());
    notifyListeners();
  }
}
