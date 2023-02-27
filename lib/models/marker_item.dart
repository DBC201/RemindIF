import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerItem {
  String title;
  Marker marker;
  int meterProximity;

  MarkerItem({required this.title, required this.marker, required this.meterProximity});
}
