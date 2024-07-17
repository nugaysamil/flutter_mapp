// ignore_for_file: use_build_context_synchronously, use_colored_box, inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/customer_data.dart';
import 'package:task_map/feature/model/route_model.dart' as model;
import 'package:task_map/feature/view/map/map_view.dart';
import 'package:task_map/feature/view/route/mixin/route_mixin.dart';
import 'package:task_map/feature/view_model/route_list_view_model.dart';
import 'package:task_map/product/utils/const/string_constant.dart';

class RouteListScreen extends ConsumerStatefulWidget {
  const RouteListScreen({
    required this.completedMarkers,
    super.key,
    this.selectedMarker,
  });

  final latLng.LatLng? selectedMarker;
  final List<latLng.LatLng> completedMarkers;

  @override
  _RouteListScreenState createState() => _RouteListScreenState();
}

class _RouteListScreenState extends ConsumerState<RouteListScreen>
    with RouteListMixin {
  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routeListViewModelProvider);
    final customers = ref.read(routeListViewModelProvider.notifier).customers;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const OrderFiltering(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(StringConstant.today),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                final customer = customers[index];
                final isCompleted =
                    widget.completedMarkers.contains(route.destination);
                return RouteCard(
                  route: route,
                  customer: customer,
                  isCompleted: isCompleted,
                  completedMarkers: widget.completedMarkers,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.orderSearch),
      backgroundColor: const Color(0xFF1A73E8),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class OrderFiltering extends StatelessWidget {
  const OrderFiltering({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A73E8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white),
                Text(
                  StringConstant.august,
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: index == 3 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index == 3 ? Colors.blue : Colors.white,
                        ),
                      ),
                      Text(
                        [
                          'Paz',
                          'Pzt',
                          'Sal',
                          'Çar',
                          'Per',
                          'Cum',
                          'Cmt',
                        ][index],
                        style: TextStyle(
                          color: index == 3 ? Colors.blue : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              StringConstant.offerFiltering,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  const RouteCard({
    required this.route,
    required this.customer,
    required this.isCompleted,
    required this.completedMarkers,
    super.key,
  });

  final model.Route route;
  final CustomerData customer;
  final bool isCompleted;
  final List<latLng.LatLng> completedMarkers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final currentPosition = await RouteListMixin.getCurrentLocation();

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              destination: route.destination,
              currentLocation: currentPosition,
              customerName: customer.name,
              customerAddress: customer.address,
              customerPhoneNumber: customer.phoneNumber,
              customerPhotoUrl: customer.photoUrl,
              material: customer.material,
              completedMarkers: completedMarkers,
              destinations: [route.destination, ...completedMarkers],
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          route.km,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.blue,
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.dateStart,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        route.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.dateEnd,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringConstant.transportType,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.transportType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringConstant.weight,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.weight,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringConstant.distance,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.distance,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
