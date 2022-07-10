import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/shared/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class RoutesStore {
  final BehaviorSubject<List<MotionRoute>?> _motionRoutes =
      BehaviorSubject.seeded(null);
  final BehaviorSubject<MotionRoute?> _selectedRoute =
      BehaviorSubject.seeded(null);
  final BehaviorSubject<Tuple2<Set<Polyline>, Set<Marker>>>
      _selectedRoutePolylinesAndMarkers =
      BehaviorSubject.seeded(Tuple2({}, {}));

  ValueStream<List<MotionRoute>?> get motionRoutes$ => _motionRoutes.stream;
  ValueStream<MotionRoute?> get selectedRoute$ => _selectedRoute.stream;
  ValueStream<Tuple2<Set<Polyline>, Set<Marker>>>
      get selectedRoutePolylinesAndMarkers$ =>
          _selectedRoutePolylinesAndMarkers.stream;

  List<MotionRoute>? get motionRoutes => _motionRoutes.valueOrNull;
  MotionRoute? get selectedRoute => _selectedRoute.valueOrNull;
  Tuple2<Set<Polyline>, Set<Marker>> get selectedRoutePolylinesAndMarkers =>
      _selectedRoutePolylinesAndMarkers.value;

  addRoute(MotionRoute route) {
    _motionRoutes.value!.add(route);
  }

  setRoutes(List<MotionRoute>? routes) {
    _motionRoutes.add(routes);
  }

  clearRoutes() {
    _motionRoutes.add(null);
  }

  disposeRoutes() {
    _motionRoutes.close();
  }

  setSelectedRoute(MotionRoute? route) {
    _selectedRoute.add(route);
    if (route != null &&
        route.polylines != null &&
        route.polylines!.isNotEmpty) {
      Set<Polyline> polylines = {};

      polylines.add(Polyline(
        color: Colors.red,
        width: 5,
        polylineId: PolylineId("main"),
        points: route.polylines!,
      ));

      Set<Marker> markers = {};

      markers.add(Marker(
          markerId: MarkerId("origin"),
          position: LatLng(
            route.origin!.latitude,
            route.origin!.longitude,
          ),
          onTap: () {
            mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(
                    route.origin!.latitude,
                    route.origin!.longitude,
                  ),
                  14),
            );
          },
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));

      markers.add(Marker(
          markerId: MarkerId("destination"),
          position: LatLng(
            route.destination!.latitude,
            route.destination!.longitude,
          ),
          onTap: () {
            mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(
                    route.destination!.latitude,
                    route.destination!.longitude,
                  ),
                  14),
            );
          },
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));

      _selectedRoutePolylinesAndMarkers.add(Tuple2(polylines, markers));
    } else {
      _selectedRoutePolylinesAndMarkers.add(Tuple2({}, {}));
    }
  }
}

RoutesStore routesStore = RoutesStore();
