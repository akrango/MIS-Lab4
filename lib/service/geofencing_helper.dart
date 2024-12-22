// import 'package:geofence_flutter/geofence_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// class GeofenceHelper {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   GeofenceHelper(this.flutterLocalNotificationsPlugin);

//   // Initialize geofencing
//   Future<void> initializeGeofencing() async {
//     GeofenceFlutter.addGeofenceEventListener((GeofenceEvent event, String id) {
//       if (event == GeofenceEvent.enter) {
//         _showNotification(
//           title: "Event Nearby",
//           body: "You are near an event!",
//         );
//       }
//     });
//   }

//   // Show a local notification
//   void _showNotification({required String title, required String body}) {
//     NotificationHelper().showNotification(id: 0, title: title, body: body);
//   }

//   // Add a geofence to a location
//   Future<void> addGeofence(double latitude, double longitude, double radius) async {
//     Geofence geofence = Geofence(
//       id: 'event_location',  // Unique ID
//       latitude: latitude,
//       longitude: longitude,
//       radius: radius,  // Set the radius for the geofence in meters
//     );
    
//     await GeofenceFlutter.addGeofence(geofence);
//   }

//   // Remove a geofence
//   Future<void> removeGeofence(String id) async {
//     await GeofenceFlutter.removeGeofence(id);
//   }
// }
