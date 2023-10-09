# remind_if
This is a simple app that draws a circle with set radius on the map and notifies when the user
enters it. 

***The background task won't start when the phone is restarted until the app is opened once.***

## Setup

### Commands to run
- ```flutter pub get``` to get flutter packages
- ```flutter packages pub run build_runner build``` to build hive adapters
- ```flutter pub run flutter_launcher_icons``` to build app icon (located in /assets/icon/icon.png)

### .env
```
google_maps_api_key="api_key"
```

### Notes
- App name can be changed from /android/app/src/AndroidManifest.xml ```android:label="RemindIF"```
- ```flutter logs``` can be used to view logs from device while running release app
