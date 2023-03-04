import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:remind_if/providers/map_controller_provider.dart';
import 'package:remind_if/providers/marker_provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final mapControllerProvider = context.read<MapControllerProvider>();
    return Drawer(
      child: Consumer<MarkerProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.markerItems?.length,
            itemBuilder: (BuildContext context, int index) {
              final key = provider.markerItems?.keys.elementAt(index);
              final value = provider.markerItems?[key];
              return ListTile(
                title: Text(value?.title ?? ''),
                onTap: () async {
                  final marker = value?.marker;
                  if (marker != null) {
                    final cameraPosition = CameraPosition(
                      target: marker.position,
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


