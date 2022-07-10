import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/services/mapServices.dart';
import 'package:assignment/store/routesStore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';

class CacheServices {
  static getCache() async {
    //open database and create routes table with first route if there is no routes table
    var db = await openDatabase('routes.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE routes (id INTEGER PRIMARY KEY, originName TEXT, destinationName TEXT, origin TEXT, destination TEXT, estimatedTravelTime TEXT, estimatedTravelDistance TEXT, polylines TEXT)');

      MotionRoute motionRoute =
          await MapServices.getRouteFromOriginToDestination(
              originName: "Berlin",
              originLatLng: LatLng(52.52, 13.405),
              destinationName: "Leipzig",
              destinationLatLng: LatLng(51.3397, 12.3731));

      await db.insert("routes", motionRoute.toMap());
    });

    //get all routes that are cached
    List<Map<String, Object?>> records = await db.query('routes');

    routesStore.setRoutes(
        records.map((e) => MotionRoute.fromMap(e)).toList().reversed.toList());
    if (routesStore.motionRoutes != null) {
      MapServices.setSelectedRouteAndAnimateToIt(
          routesStore.motionRoutes!.first);
    }
  }

  static Future<void> insertRouteToCache(MotionRoute motionRoute) async {
    var db = await openDatabase('routes.db', version: 1,
        //if it is first time opening this database
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE routes (id INTEGER PRIMARY KEY, originName TEXT, destinationName TEXT, origin TEXT, destination TEXT, estimatedTravelTime TEXT, estimatedTravelDistance TEXT, polylines TEXT)');
    });

    await db.insert("routes", motionRoute.toMap());

    //get all routes that are cached
    List<Map<String, Object?>> records = await db.query('routes');

    routesStore.setRoutes(
        records.map((e) => MotionRoute.fromMap(e)).toList().reversed.toList());
  }
}
