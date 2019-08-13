import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geohex/geohex.dart';

class _MyHomePageState extends State<MyHomePage> {
  final polygons = <Polygon>[];
  final markers = <Marker>[];
  final controller = MapController();

  void addMarkerAndHex(LatLng point) {
    markers.add(
        Marker(point: point, builder: (context) => Icon(Icons.location_on)));
    final zone = Zone.byLocation(point.latitude, point.longitude,
        int.parse((controller.zoom / 2).toStringAsFixed(0)));
    final hex = zone.hexCoords;
    final coords = <LatLng>[];
    for (final item in hex) {
      coords.add(LatLng(item.lat, item.lon));
    }
    polygons.add(Polygon(
        points: coords,
        color: Colors.transparent,
        borderStrokeWidth: 5.0,
        borderColor: Colors.limeAccent));
    print(polygons.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
            center: LatLng(48.853831, 2.348722),
            zoom: 12.0,
            onTap: addMarkerAndHex),
        layers: [
          TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers),
          PolygonLayerOptions(polygons: polygons),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter map GeoHex Demo',
      home: MyHomePage(),
    );
  }
}
