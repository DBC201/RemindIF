import 'package:hive/hive.dart';

part 'marker_adapter.g.dart';

@HiveType(typeId: 0)
class MarkerAdapter extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  double latitude;
  @HiveField(2)
  double longtitude;
  @HiveField(3)
  int meterProximity;

  MarkerAdapter({required this.title, required this.latitude, required this.longtitude, required this.meterProximity});
}
