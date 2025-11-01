import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Tracking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DriverMapPage(),
    );
  }
}

class DriverMapPage extends StatefulWidget {
  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  LatLng? driverLocation;
  final mapController = MapController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLocation();
    _timer = Timer.periodic(Duration(seconds: 10), (_) => fetchLocation());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchLocation() async {
    final url = "http://192.168.186.176:8000/api/location20/latest/B1";
    debugPrint("Fetching from URL: $url");

    try {
      final response = await http.get(Uri.parse(url));

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Decoded response: $data');

        double lat = double.parse(data['latitude'].toString());
        double lng = double.parse(data['longitude'].toString());

        LatLng newLocation = LatLng(lat, lng);

        if (driverLocation == null || driverLocation != newLocation) {
          setState(() {
            driverLocation = newLocation;
          });
          mapController.move(driverLocation!, 13.0); // Zoom افتراضي
          debugPrint('Driver location updated: $driverLocation');
        }
      } else {
        debugPrint('Failed to fetch location: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Location")),
      body: driverLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(center: driverLocation, zoom: 13),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: driverLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
