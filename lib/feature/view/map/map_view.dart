// lib/feature/view/map/map_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/marker_data.dart';
import 'package:task_map/feature/view/map/mixin/map_controller_mixin.dart';
import 'package:task_map/feature/view_model/map_view_model.dart';
import 'package:task_map/product/utils/const/string_constant.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    required this.destination,
    required this.currentLocation,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhoneNumber,
    required this.customerPhotoUrl,
    required this.material,
    required this.destinations,
    this.completedMarkers = const [],
    super.key,
  });

  final latLng.LatLng destination;
  final latLng.LatLng currentLocation;
  final String customerName;
  final String customerAddress;
  final String customerPhoneNumber;
  final String customerPhotoUrl;
  final String material;
  final List<latLng.LatLng> destinations;
  final List<latLng.LatLng> completedMarkers;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with MapControllerMixin<MapScreen> {
  @override
  void initState() {
    super.initState();
    currentPosition = widget.currentLocation;
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final polylinePoints = calculatePolyline(
      currentPosition,
      widget.destination,
      widget.destinations,
    );

    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.read(mapViewModelProvider.notifier);
        final isCardVisible = ref.watch(mapViewModelProvider).isCardVisible;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.init(
            mapController: mapController,
            markers: markers,
            currentPosition: currentPosition,
            route: polylinePoints,
          );
        });

        return Scaffold(
          appBar: const _CustomAppBar(),
          body: Stack(
            children: [
              CustomMapLayer(
                mapController: mapController,
                markers: markers,
                currentLocation: currentPosition,
                destination: widget.destination,
                completedMarkers: widget.completedMarkers,
                polylinePoints: polylinePoints,
                viewModel: viewModel,
              ),
              if (isCardVisible)
                MapCard(
                  customerPhotoUrl: widget.customerPhotoUrl,
                  customerName: widget.customerName,
                  customerPhoneNumber: widget.customerPhoneNumber,
                  customerAddress: widget.customerAddress,
                  material: widget.material,
                  onPressed: () {
                    zoomToCurrentLocation(currentPosition);
                    viewModel.setCardVisibility(false);
                  },
                ),
              if (!isCardVisible)
                CompleteOrderButton(
                  onPressed: () {
                    stopOrder(
                      currentPosition,
                      context,
                      widget.completedMarkers,
                      widget.destination,
                      () => viewModel.setCardVisibility(true),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.mapScreen),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight);
}

class CustomMapLayer extends StatelessWidget {
  const CustomMapLayer({
    required this.mapController,
    required this.markers,
    required this.currentLocation,
    required this.destination,
    required this.completedMarkers,
    required this.polylinePoints,
    required this.viewModel,
    super.key,
  });

  final MapController mapController;
  final List<MapMarker> markers;
  final latLng.LatLng currentLocation;
  final latLng.LatLng destination;
  final List<latLng.LatLng> completedMarkers;
  final List<latLng.LatLng> polylinePoints;
  final MapViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      children: [
        TileLayer(
          urlTemplate: StringConstant.urlTemplated,
          userAgentPackageName: StringConstant.userAgentPackageName,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: currentLocation,
              child: GestureDetector(
                onTap: () {
                  viewModel.onMarkerTapped(currentLocation);
                },
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            Marker(
              point: destination,
              child: GestureDetector(
                onTap: () {
                  viewModel.onMarkerTapped(destination);
                },
                child: Icon(
                  Icons.location_pin,
                  color: completedMarkers.contains(destination)
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
            ...markers.map((marker) {
              return Marker(
                point: marker.point,
                child: GestureDetector(
                  onTap: () {
                    viewModel.onMarkerTapped(marker.point);
                  },
                  child: Icon(
                    Icons.location_pin,
                    color: completedMarkers.contains(marker.point)
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
              );
            }),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: polylinePoints,
              strokeWidth: 4,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }
}

class MapCard extends StatelessWidget {
  const MapCard({
    required this.customerPhotoUrl,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerAddress,
    required this.material,
    required this.onPressed,
    super.key,
  });

  final String customerPhotoUrl;
  final String customerName;
  final String customerPhoneNumber;
  final String customerAddress;
  final String material;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(customerPhotoUrl),
                      radius: 30,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(customerPhoneNumber),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.red),
                      onPressed: () {
                        // Call action
                      },
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(customerAddress),
                  trailing:
                      Text('${StringConstant.materialToBeDelivered} $material'),
                  dense: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      StringConstant.goToLocation,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CompleteOrderButton extends StatelessWidget {
  const CompleteOrderButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringConstant.completeOrder,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
