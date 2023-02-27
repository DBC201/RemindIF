import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:remind_if/models/marker_adapter.dart';
import 'package:remind_if/providers/map_controller_provider.dart';
import 'package:remind_if/providers/marker_provider.dart';
import 'package:remind_if/util/notification_service.dart';
import 'package:remind_if/widgets/map_widget.dart';
import 'package:remind_if/widgets/menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  var appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(MarkerAdapterAdapter());
  runApp(const MyApp());
  await Permission.notification.isDenied.then((value) {
    if (value) {
      //Permission.notification.request();
      notificationService.notify("welcome to Remind If", '');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarkerProvider>(create: (_) => MarkerProvider()),
        ChangeNotifierProvider<MapControllerProvider>(create: (_) => MapControllerProvider())
      ],
      child: WidgetsApp(
        color: Colors.red,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Remind If',
            home: const MyMap(),
            theme: ThemeData(
              primaryColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Menu()),
      appBar: AppBar(
        title: const Text('Remind If'),
        backgroundColor: Theme.of(context).primaryColor
      ),
      body: MapWidget(parentContext: context,)
    );
  }
}
