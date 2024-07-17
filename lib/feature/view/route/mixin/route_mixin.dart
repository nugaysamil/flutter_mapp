// lib/feature/view/route/route_list_mixin.dart

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/location_model.dart';

mixin RouteListMixin<T extends StatefulWidget> on State<T> {
  static Future<latLng.LatLng> getCurrentLocation() async {
    final position = await LocationModel().determinePosition();
    return latLng.LatLng(position.latitude, position.longitude);
  }
}
