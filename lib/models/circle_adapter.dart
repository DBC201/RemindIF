import 'package:hive/hive.dart';

part 'circle_adapter.g.dart';

@HiveType(typeId: 0)
class CircleAdapter extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  double latitude;
  @HiveField(2)
  double longtitude;
  @HiveField(3)
  double radius;

  CircleAdapter({required this.title, required this.latitude, required this.longtitude, required this.radius});
}
