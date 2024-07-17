// lib/feature/view_model/route_list_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:task_map/feature/model/customer_data.dart';
import 'package:task_map/feature/model/route_model.dart';
import 'package:task_map/product/utils/const/string_constant.dart';

class RouteListViewModel extends StateNotifier<List<Route>> {
  RouteListViewModel() : super(_initialRoutes);

  static final List<Route> _initialRoutes = [
    Route(
      start: StringConstant.currentLocation,
      end: StringConstant.istinye,
      dateStart: '24.07.2024',
      dateEnd: '27.07.2024',
      transportType: StringConstant.eurotruck,
      weight: '869 kg',
      distance: '1 450 km',
      km: '5 km',
      destination: const latLng.LatLng(38.39803, 27.0681),
    ),
    Route(
      start: StringConstant.currentLocation,
      end: StringConstant.ucKuyular,
      dateStart: '25.07.2024',
      dateEnd: '28.07.2024',
      transportType: StringConstant.gasolineTanker,
      weight: '900 kg',
      distance: '1 600 km',
      km: '10 km',
      destination: const latLng.LatLng(38.404865, 27.069399),
    ),
    Route(
      start: StringConstant.currentLocation,
      end: StringConstant.inciralti,
      dateStart: '26.07.2024',
      dateEnd: '29.07.2024',
      transportType: StringConstant.freightliner,
      weight: '950 kg',
      distance: '1 750 km',
      km: '15 km',
      destination: const latLng.LatLng(38.399406, 27.037010),
    ),
  ];

  List<CustomerData> get customers => CustomerDataList.customers;
}

final routeListViewModelProvider =
    StateNotifierProvider<RouteListViewModel, List<Route>>((ref) {
  return RouteListViewModel();
});
