import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/product/utils/const/string_constant.dart';

class MapMarker {
  const MapMarker({
    required this.point,
    required this.label,
    required this.child,
  });
  final latLng.LatLng point;
  final String label;
  final Widget child;
}

class MarkerData {
  static final List<MapMarker> markers = [
    const MapMarker(
      point: latLng.LatLng(38.39803, 27.0681),
      label: StringConstant.istinye,
      child: Icon(Icons.location_pin),
    ),
    const MapMarker(
      point: latLng.LatLng(38.404865, 27.069399),
      label: StringConstant.ucKuyular,
      child: Icon(Icons.location_pin),
    ),
    const MapMarker(
      point: latLng.LatLng(38.399406, 27.037010),
      label: StringConstant.inciralti,
      child: Icon(Icons.location_pin),
    ),
  ];
}
