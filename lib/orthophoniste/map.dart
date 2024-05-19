import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class map extends StatefulWidget {
  const map({Key? key}) : super(key: key);

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  MapController mapController = MapController();
  LatLng userLocation =
      LatLng(35.769260, 10.819970); // Initialize with default value
  LatLng petLocation =
      LatLng(35.829300, 10.640630); // Example location for Monastir

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<LatLng> getCoordinates(String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lng = double.parse(data[0]['lon']);
          print("++++++++++++++++++++++${LatLng(lat, lng)}");
          return LatLng(lat, lng);
        } else {
          throw 'Error: No results found';
        }
      } else {
        throw 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error getting coordinates: $e');

      return LatLng(0, 0); // Return default coordinates on error
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(
      LengthUnit.Meter,
      LatLng(start.latitude, start.longitude),
      LatLng(end.latitude, end.longitude),
    );
  }

  /* void launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      print('Could not launch $url');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:
            const Text('Pet Location', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => mapController.move(
                mapController.camera.center, mapController.camera.zoom + 1),
          ),
          IconButton(
            icon: const Icon(Icons.padding, color: Colors.white),
            onPressed: () => getCoordinates(
                "String address = 'Pôle Médical Eya, 4ème étage, Place du Savoir, Monastir "),
          ),
          IconButton(
            icon: Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () => mapController.move(
                mapController.camera.center, mapController.camera.zoom - 1),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Expanded(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: userLocation,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.firstflutter pub add url_launcher_android',
                    ),
                    /*  RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),*/
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLocation,
                          child: const Icon(Icons.location_on_rounded,
                              color: Colors.red),
                        ),
                        Marker(
                          point: petLocation,
                          child: Icon(Icons.location_pin, color: Colors.blue),
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [userLocation, petLocation],
                          strokeWidth: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: ElevatedButton(
              onPressed: () {
                double distance = calculateDistance(userLocation, petLocation);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Distance to Pet Location'),
                      content: Text('Distance: $distance meters'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Calculate Distance'),
            ),
          ),
        ],
      ),
    );
  }
}
