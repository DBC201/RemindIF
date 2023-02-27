import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/marker_provider.dart';
import 'input_box.dart';
import 'marker_dialog.dart';

class AddMarker extends StatefulWidget {
  LatLng latLng;
  BuildContext parentContext;

  AddMarker({required this.latLng, required this.parentContext});

  @override
  _AddMarkerState createState() => _AddMarkerState(latLng: this.latLng, parentContext: this.parentContext);
}

class _AddMarkerState extends State<AddMarker> {
  LatLng latLng;
  BuildContext parentContext;

  _AddMarkerState({required this.latLng, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final markerProvider = context.read<MarkerProvider>();
    return AlertDialog(
      title: Text('Add Marker'),
      content: InputBox(
        onSubmit: (String title, int proximity) {
          if (title.isEmpty) {
            Navigator.pop(context);
            return;
          }
          Marker marker = Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MarkerDialog(
                      markerId: MarkerId(latLng.toString()),
                    );
                  },
                ),
              );
            },
          );
          markerProvider.addMarker(marker, title, proximity);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
