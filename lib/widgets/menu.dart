import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:remind_if/providers/map_controller_provider.dart';
import 'package:remind_if/providers/circle_provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final mapControllerProvider = context.read<MapControllerProvider>();
    return Drawer(
      child: Consumer<CircleProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.circleItems?.length,
            itemBuilder: (BuildContext context, int index) {
              final key = provider.circleItems?.keys.elementAt(index);
              final value = provider.circleItems?[key];
              return ListTile(
                title: Text(value?.title ?? ''),
                onTap: () async {
                  final circle = value?.circle;
                  if (circle != null) {
                    final cameraPosition = CameraPosition(
                      target: circle.center,
                      zoom: 15,
                    );
                    await mapControllerProvider.mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}


