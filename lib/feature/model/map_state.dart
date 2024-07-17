// lib/feature/view_model/map_state.dart

import 'package:latlong2/latlong.dart' as latLng;

class MapState {
  MapState({
    this.selectedMarkerPosition,
    this.currentMarkerIndex = -1,
    this.mapCenter,
    this.mapZoom = 15,
    this.polylinePoints = const [],
    this.isCardVisible = true,
  });

  final latLng.LatLng? selectedMarkerPosition;
  final int currentMarkerIndex;
  final latLng.LatLng? mapCenter;
  final double mapZoom;
  final List<latLng.LatLng> polylinePoints;
  final bool isCardVisible;

  MapState copyWith({
    String? selectedMarkerLabel,
    latLng.LatLng? selectedMarkerPosition,
    int? currentMarkerIndex,
    latLng.LatLng? mapCenter,
    double? mapZoom,
    List<latLng.LatLng>? polylinePoints,
    bool? isCardVisible,
  }) {
    return MapState(
      selectedMarkerPosition:
          selectedMarkerPosition ?? this.selectedMarkerPosition,
      currentMarkerIndex: currentMarkerIndex ?? this.currentMarkerIndex,
      mapCenter: mapCenter ?? this.mapCenter,
      mapZoom: mapZoom ?? this.mapZoom,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      isCardVisible: isCardVisible ?? this.isCardVisible,
    );
  }
}
