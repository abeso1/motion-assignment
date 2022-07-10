import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MotionRoute {
  String? originName;
  String? destinationName;
  LatLng? origin;
  LatLng? destination;
  String? estimatedTravelTime;
  String? estimatedTravelDistance;
  List<LatLng>? polylines;

  MotionRoute({
    this.originName,
    this.destinationName,
    this.origin,
    this.destination,
    this.estimatedTravelTime,
    this.estimatedTravelDistance,
    this.polylines,
  });

  MotionRoute.fromMap(Map<String, Object?> map) {
    originName = map["originName"] as String?;
    destinationName = map["destinationName"] as String?;
    origin = LatLng.fromJson(jsonDecode(map["origin"] as String));
    destination = LatLng.fromJson(jsonDecode(map["destination"] as String));
    estimatedTravelTime = map["estimatedTravelTime"] as String?;
    estimatedTravelDistance = map["estimatedTravelDistance"] as String?;
    polylines = List.from(jsonDecode(map["polylines"] as String))
        .map((item) => LatLng.fromJson(item))
        .cast<LatLng>()
        .toList();
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "originName": originName,
      "destinationName": destinationName,
      "origin": origin!.toJson().toString(),
      "destination": destination!.toJson().toString(),
      "estimatedTravelTime": estimatedTravelTime,
      "estimatedTravelDistance": estimatedTravelDistance,
      "polylines": polylines!
          .map((e) => ([e.latitude, e.longitude]).toString())
          .toList()
          .toString(),
    };
    return map;
  }
}
