// lib/feature/view_model/map_view_model.dart

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/map_state.dart';
import 'package:task_map/feature/model/marker_data.dart';

class MapViewModel extends StateNotifier<MapState> {
  MapViewModel() : super(MapState());

  late MapController mapController;
  late List<MapMarker> markers;
  late latLng.LatLng currentPosition;
  late List<latLng.LatLng> route;

  void init({
    required MapController mapController,
    required List<MapMarker> markers,
    required latLng.LatLng currentPosition,
    required List<latLng.LatLng> route,
  }) {
    this.mapController = mapController;
    this.markers = markers;
    this.currentPosition = currentPosition;
    this.route = route;
    state = state.copyWith(mapCenter: currentPosition, polylinePoints: route);
  }

  void onMarkerTapped(latLng.LatLng position) {
    state = state.copyWith(
      selectedMarkerPosition: position,
      mapCenter: position,
    );
    mapController.move(position, state.mapZoom);
  }

  void updatePolyline(List<latLng.LatLng> newPolylinePoints) {
    state = state.copyWith(polylinePoints: newPolylinePoints);
  }

  void setCardVisibility(bool isVisible) {
    state = state.copyWith(isCardVisible: isVisible);
  }
}

final mapViewModelProvider =
    StateNotifierProvider<MapViewModel, MapState>((ref) {
  return MapViewModel();
});
