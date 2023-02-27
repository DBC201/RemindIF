import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerProvider extends ChangeNotifier{
  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }
}
