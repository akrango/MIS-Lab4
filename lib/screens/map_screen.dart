// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/event_provider.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final events = Provider.of<EventProvider>(context).events;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Map')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(events[0].latitude, events[0].longitude),
//           zoom: 14,
//         ),
//         markers: events
//             .map((e) => Marker(
//                   markerId: MarkerId(e.title),
//                   position: LatLng(e.latitude, e.longitude),
//                   infoWindow:
//                       InfoWindow(title: e.title, snippet: e.locationName),
//                 ))
//             .toSet(),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:calendar_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:calendar_app/providers/event_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set();
  Set<Polyline> polylines = Set();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus locationPermission = await Permission.location.request();
    PermissionStatus backgroundLocationPermission =
        await Permission.locationAlways.request();

    if (locationPermission.isGranted &&
        backgroundLocationPermission.isGranted) {
      _getCurrentLocation();
    } else {
      print("Location permission denied");
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print("POSITION: ${position.latitude}, ${position.longitude}");
    setState(() {
      _currentPosition = position;
    });

    _addMarker(position.latitude, position.longitude, "Your Location");

    final events = Provider.of<EventProvider>(context, listen: false).events;

    for (var event in events) {
      _addEventMarker(event);
    }
  }

  void _addMarker(double lat, double lng, String title) {
    markers.add(Marker(
      markerId: MarkerId(title),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title),
    ));
    setState(() {});
  }

  void _addEventMarker(Event event) {
    markers.add(Marker(
      markerId: MarkerId(event.title),
      position: LatLng(event.latitude, event.longitude),
      infoWindow: InfoWindow(title: event.title),
      onTap: () {
        _onMarkerTapped(event.latitude, event.longitude);
      },
    ));
    setState(() {});
  }

  void _onMarkerTapped(double eventLat, double eventLng) {
    if (_currentPosition != null) {
      _getRoute(_currentPosition!.latitude, _currentPosition!.longitude,
          eventLat, eventLng);
    } else {
      print('Current location not available yet');
    }
  }

  Future<void> _getRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=API_KEY");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final points =
            _decodePolyLine(routes[0]['overview_polyline']['points']);
        _addPolyline(points);
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePolyLine(String polyline) {
    List<LatLng> polylineList = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      while (true) {
        int c = polyline.codeUnitAt(index) - 63;
        index++;
        result |= (c & 0x1f) << shift;
        shift += 5;
        if (c < 0x20) break;
      }
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      while (true) {
        int c = polyline.codeUnitAt(index) - 63;
        index++;
        result |= (c & 0x1f) << shift;
        shift += 5;
        if (c < 0x20) break;
      }
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylineList.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineList;
  }

  void _addPolyline(List<LatLng> points) {
    polylines.add(Polyline(
      polylineId: PolylineId('route'),
      visible: true,
      points: points,
      color: Colors.blue,
      width: 5,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route to Event')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: markers,
              polylines: polylines,
            ),
    );
  }
}
