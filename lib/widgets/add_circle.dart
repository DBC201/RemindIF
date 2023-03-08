import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/circle_provider.dart';
import 'input_box.dart';
import 'circle_dialog.dart';

class AddCircle extends StatefulWidget {
  LatLng latLng;
  BuildContext parentContext;

  AddCircle({required this.latLng, required this.parentContext});

  @override
  _AddCircleState createState() => _AddCircleState(latLng: this.latLng, parentContext: this.parentContext);
}

class _AddCircleState extends State<AddCircle> {
  LatLng latLng;
  BuildContext parentContext;

  _AddCircleState({required this.latLng, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final circleProvider = context.read<CircleProvider>();
    return AlertDialog(
      title: Text('Add Reminder Area'),
      content: InputBox(
        onSubmit: (String title, double radius) {
          if (title.isEmpty || radius <= 0) {
            Navigator.pop(context);
            return;
          }
          Circle circle = Circle(
            circleId: CircleId(latLng.toString()),
            center: latLng,
            radius: radius,
            fillColor: Colors.blueAccent.withOpacity(0.5),
            strokeWidth: 3,
            strokeColor: Colors.blueAccent,
            consumeTapEvents: true,
            onTap: () {
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CircleDialog(
                      circleId: CircleId(latLng.toString()),
                    );
                  },
                ),
              );
            },
          );
          circleProvider.addCircle(circle, title, radius);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
