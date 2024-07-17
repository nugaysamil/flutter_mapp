// lib/feature/model/route.dart

// ignore_for_file: library_prefixes

import 'package:latlong2/latlong.dart' as latLng;

class Route {
  Route({
    required this.start,
    required this.end,
    required this.dateStart,
    required this.dateEnd,
    required this.transportType,
    required this.weight,
    required this.distance,
    required this.km,
    required this.destination,
  });
  final String start;
  final String end;
  final String dateStart;
  final String dateEnd;
  final String transportType;
  final String weight;
  final String distance;
  final String km;
  final latLng.LatLng destination;
}
