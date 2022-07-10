import 'dart:convert';
import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/shared/globalVariables.dart';
import 'package:assignment/store/routesStore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class MapServices {
  static Future<MotionRoute> getRouteFromOriginToDestination({
    required String originName,
    required String destinationName,
    required LatLng originLatLng,
    required LatLng destinationLatLng,
  }) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?";

    url += "&origin=" +
        originLatLng.latitude.toString() +
        "," +
        originLatLng.longitude.toString();

    url += "&destination=" +
        destinationLatLng.latitude.toString() +
        "," +
        destinationLatLng.longitude.toString();

    url += "&key=$mapKey";

    http.Response response = await http.get(Uri.parse(url));

    Map values = jsonDecode(response.body);

    String points = values["routes"][0]["overview_polyline"]["points"];

    String estimatedTravelTime =
        values["routes"][0]["legs"][0]["duration"]["text"];
    String estimatedTravelDistance =
        values["routes"][0]["legs"][0]["distance"]["text"];

    PolylinePoints polylinePointsFlutter = PolylinePoints();
    List<PointLatLng> result = polylinePointsFlutter.decodePolyline(points);

    return MotionRoute(
      originName: originName,
      destinationName: destinationName,
      origin: LatLng(originLatLng.latitude, originLatLng.longitude),
      destination:
          LatLng(destinationLatLng.latitude, destinationLatLng.longitude),
      estimatedTravelDistance: estimatedTravelDistance,
      estimatedTravelTime: estimatedTravelTime,
      polylines: result.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    );
  }

  static LatLngBounds getMapBounds(Set<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  static setSelectedRouteAndAnimateToIt(MotionRoute motionRoute) {
    routesStore.setSelectedRoute(motionRoute);
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        MapServices.getMapBounds(
            routesStore.selectedRoutePolylinesAndMarkers.item2),
        100));
  }
}
