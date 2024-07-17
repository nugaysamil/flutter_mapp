// lib/feature/view/map/mixin/map_controller_mixin.dart

// ignore_for_file: cascade_invocations, inference_failure_on_instance_creation, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/location_model.dart';
import 'package:task_map/feature/model/marker_data.dart';
import 'package:task_map/feature/view/route/route_view.dart';
import 'package:task_map/product/utils/const/string_constant.dart';

mixin MapControllerMixin<T extends StatefulWidget> on State<T> {
  final MapController mapController = MapController();
  final List<MapMarker> markers = MarkerData.markers;

  latLng.LatLng currentPosition = const latLng.LatLng(38.4186, 27.1274);
  List<latLng.LatLng> route = [];
  String locationMessage = '';

  Future<void> getCurrentLocation() async {
    try {
      final position = await LocationModel().determinePosition();
      setState(() {
        currentPosition = latLng.LatLng(position.latitude, position.longitude);
        mapController.move(currentPosition, 13.2);
      });
    } catch (e) {
      setState(() {
        locationMessage = 'Error: $e';
      });
    }
  }

  void zoomToCurrentLocation(latLng.LatLng currentLocation) {
    mapController.move(currentLocation, 15);
  }

  void stopOrder(
    latLng.LatLng currentLocation,
    BuildContext context,
    List<latLng.LatLng> completedMarkers,
    latLng.LatLng destination,
    VoidCallback onComplete,
  ) {
    mapController.move(currentLocation, 15);
    showStopOrderDialog(context, () {
      final List<latLng.LatLng> newCompletedMarkers =
          List.from(completedMarkers);
      newCompletedMarkers.add(destination);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RouteListScreen(
            selectedMarker: destination,
            completedMarkers: newCompletedMarkers,
          ),
        ),
      );
      onComplete();
    });
  }

  void showStopOrderDialog(BuildContext context, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstant.completeOrder),
          content: const Text(StringConstant.continueWithOtherOrders),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(StringConstant.no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onComplete();
              },
              child: const Text(StringConstant.yes),
            ),
          ],
        );
      },
    );
  }

  List<latLng.LatLng> calculatePolyline(
    latLng.LatLng start,
    latLng.LatLng selectedMarker,
    List<latLng.LatLng> destinations,
  ) {
    final List<latLng.LatLng> polylinePoints = [start, selectedMarker];
    final List<latLng.LatLng> remainingDestinations = List.from(destinations)
      ..remove(selectedMarker);

    while (remainingDestinations.isNotEmpty) {
      remainingDestinations.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          polylinePoints.last.latitude,
          polylinePoints.last.longitude,
          a.latitude,
          a.longitude,
        );
        final distB = Geolocator.distanceBetween(
          polylinePoints.last.latitude,
          polylinePoints.last.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });
      final nextPoint = remainingDestinations.removeAt(0);
      polylinePoints.add(nextPoint);
    }

    return polylinePoints;
  }
}
