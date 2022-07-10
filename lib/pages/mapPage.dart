import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/pages/routesPage.dart';
import 'package:assignment/services/cacheServices.dart';
import 'package:assignment/shared/globalVariables.dart';
import 'package:assignment/store/routesStore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
          stream: routesStore.selectedRoutePolylinesAndMarkers$,
          builder: (context,
              AsyncSnapshot<Tuple2<Set<Polyline>, Set<Marker>>>
                  routePolylinesAndMarkersSnapshot) {
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  rotateGesturesEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(6.1, 18),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(51.1657, 10.4515),
                    zoom: 0,
                  ),
                  polylines: routePolylinesAndMarkersSnapshot.data == null
                      ? {}
                      : routePolylinesAndMarkersSnapshot.data!.item1,
                  markers: routePolylinesAndMarkersSnapshot.data == null
                      ? {}
                      : routePolylinesAndMarkersSnapshot.data!.item2,
                  onMapCreated: (GoogleMapController controller) {
                    completer.complete(controller);
                    mapController = controller;
                  },
                ),
                _buildRouteDetails(),
              ],
            );
          }),
    );
  }

  StreamBuilder<MotionRoute?> _buildRouteDetails() {
    return StreamBuilder(
        stream: routesStore.selectedRoute$,
        builder: (context, AsyncSnapshot<MotionRoute?> route) {
          if (route.connectionState == ConnectionState.waiting ||
              !route.hasData) {
            return Container();
          } else {
            return Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Text(
                            route.data!.originName!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Icon(Icons.remove),
                        Flexible(
                          child: Text(
                            route.data!.destinationName!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ]),
                ),
                bottom: 0,
                left: 0,
                right: 0);
          }
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      actions: [
        FutureBuilder(
            future: CacheServices.getCache(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RoutesPage()));
                    },
                    child: Text("Routes"));
              } else {
                return Center(
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator()),
                );
              }
            })
      ],
      backgroundColor: Colors.white,
      title: Text("Motion Assignment",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          )),
    );
  }
}
