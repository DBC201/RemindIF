import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:remind_if/providers/map_controller_provider.dart';
import 'package:remind_if/providers/circle_provider.dart';
import 'package:remind_if/util/background_service.dart';
import 'package:remind_if/util/notification_service.dart';
import 'package:remind_if/widgets/map_widget.dart';
import 'package:remind_if/widgets/menu.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/circle_adapter.dart';

BackgroundService backgroundService = BackgroundService();

bool has_permission = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(CircleAdapterAdapter());
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CircleProvider>(create: (_) => CircleProvider()),
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
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (has_permission) {
      return;
    }
    bool notificationPermission = await Permission.notification.isGranted;
    if (!notificationPermission) {
      var askAgain = await Permission.notification.request();
      if (askAgain.isDenied) {
        await notificationService.notify("welcome to Remind If", '');
      }
    }
    bool notificationGranted = await Permission.notification.isGranted;
    bool locationGranted = await Permission.locationAlways.isGranted;

    if (!notificationGranted || !locationGranted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Inadequate Permissions"),
            content: Text("${!notificationGranted ? "\"Notifications\"" : ''} ${!notificationGranted && !locationGranted ? 'and' : ''} ${!locationGranted ? "\"Allow Location all the time\"" : ''} disabled. Please enable these permissions from settings. A restart is needed."),
            actions: [
              TextButton(
                child: Text("Settings"),
                onPressed: () {
                  openAppSettings();
                },
              ),
              TextButton(onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                }
                else if (Platform.isIOS) {
                  exit(0);
                }
              }, child: Text("Quit"))
            ],
          );
        },
      );
    }
    else {
      backgroundService.init();
      has_permission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Menu()),
      appBar: AppBar(
        title: const Text('RemindIF'),
        backgroundColor: Theme.of(context).primaryColor
      ),
      body: MapWidget(parentContext: context,)
    );
  }
}
