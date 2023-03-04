import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:remind_if/models/marker_item.dart';
import 'package:google_maps_utils/google_maps_utils.dart' as gm_utils;
import 'package:remind_if/util/notification_service.dart';
import 'dart:math';

import '../providers/map_controller_provider.dart';
import '../providers/marker_provider.dart';
import 'add_marker.dart';


class MapWidget extends StatefulWidget {
  BuildContext parentContext;

  MapWidget({required this.parentContext});

  @override
  _MapWidget createState() => _MapWidget(parentContext: parentContext);
}

class _MapWidget extends State<MapWidget> {
  late loc.LocationData currentPosition;
  late GoogleMapController mapController;
  final loc.Location location = loc.Location();
  Completer<bool> completer = Completer();
  BuildContext parentContext;

  _MapWidget({required this.parentContext});

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print("map widget initialized");
    }

    location.onLocationChanged.listen((loc.LocationData currentLocation) async {
      if (kDebugMode) {
        print("location foreground callback ran");
      }

      currentPosition = currentLocation;

      if (!completer.isCompleted) {
        if (kDebugMode) {
          print("completer for location foreground done");
        }
        parentContext.read<MarkerProvider>().initMarkers(parentContext);
        completer.complete(true);
      }
      /*
      CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentPosition.latitude,
              _currentPosition.longitude,
            ),
            zoom: 15,
          ));
       */
      final markerProvider = parentContext.read<MarkerProvider>();

      if (markerProvider.markerItems != null) {
        List<MarkerId> markers_to_be_deleted = [];

        var entries = markerProvider.markerItems?.entries;

        for (var item in entries!) {
          MarkerItem markerItem = item.value;
          int proximity = markerItem.meterProximity;
          double distance = gm_utils.SphericalUtils.computeDistanceBetween(
              Point(currentLocation.latitude ?? 0.0,
                  currentLocation.longitude ?? 0.0),
              Point(markerItem.marker.position.latitude,
                  markerItem.marker.position.longitude));
          if (distance <= proximity) {
            // Initialize the FlutterLocalNotificationsPlugin
            notificationService.notify(
                'You are here!', '${markerItem.title} is reached.');
            markers_to_be_deleted.add(item.key);
          }
        }

        for (var item in markers_to_be_deleted) {
          markerProvider.removeMarker(item);
        }
        markers_to_be_deleted.clear();
      }
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final mapControllerProvider = parentContext.read<MapControllerProvider>();
    mapControllerProvider.setMapController(mapController);
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: dotenv.get("google_maps_api_key"),
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    //markersList.clear();
    //markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result?.name)));

    setState(() {});

    parentContext.read<MapControllerProvider>().mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));

  }

  Future<void> _handlePressButton() async {
    if (kDebugMode) {
      print("button pressed");
      print(dotenv.get("google_maps_api_key"));
    }
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: dotenv.get("google_maps_api_key"),
        mode: Mode.overlay,
        language: 'en',
        types: [],
        strictbounds: false,
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))), components: []);

    displayPrediction(p!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: completer.future,
        builder: (context, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              if (kDebugMode) {
                print("map loaded");
              }
              return Stack(children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentPosition.latitude ?? 0.0,
                        currentPosition.longitude ?? 0.0),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: parentContext.watch<MarkerProvider>().markers,
                  onTap: (latLng) {
                    setState(() {
                      showDialog(
                          context: parentContext,
                          builder: (BuildContext context) {
                            return AddMarker(
                              latLng: latLng,
                              parentContext: parentContext,
                            );
                          });
                    });
                  },
                ),
                ElevatedButton(
                    onPressed: _handlePressButton,
                    child: const Text("Search Places"))
              ]);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
