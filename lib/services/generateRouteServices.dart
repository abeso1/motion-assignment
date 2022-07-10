import 'dart:math';
import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/services/cacheServices.dart';
import 'package:assignment/services/mapServices.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GenerateRouteServices {
  Future<void> generateNewRoute() async {
    double topMost = 50.724;
    double leftMost = 7.116;
    double bottomMost = 48.383;
    double rightMost = 12.147;

    double originLatitude = randomFromRange(bottomMost, topMost);
    double originLongitude = randomFromRange(leftMost, rightMost);

    double destinationLatitude = randomFromRange(bottomMost, topMost);
    double destinationLongitude = randomFromRange(leftMost, rightMost);

    List<Placemark> origin =
        await placemarkFromCoordinates(originLatitude, originLongitude);
    List<Placemark> destination = await placemarkFromCoordinates(
        destinationLatitude, destinationLongitude);

    MotionRoute motionRoute = await MapServices.getRouteFromOriginToDestination(
        originName: origin.first.locality ?? origin.first.country ?? "",
        originLatLng: LatLng(originLatitude, originLongitude),
        destinationName:
            destination.first.locality ?? destination.first.country ?? "",
        destinationLatLng: LatLng(destinationLatitude, destinationLongitude));

    await CacheServices.insertRouteToCache(motionRoute);
  }

  double randomFromRange(double min, double max) {
    Random random = new Random();
    return random.nextDouble() * (max - min) + min;
  }
}
