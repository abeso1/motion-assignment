import 'package:assignment/models/MotionRoute.dart';
import 'package:assignment/services/generateRouteServices.dart';
import 'package:assignment/services/mapServices.dart';
import 'package:assignment/shared/reusableWidgets.dart';
import 'package:assignment/store/routesStore.dart';
import 'package:flutter/material.dart';

class RoutesPage extends StatefulWidget {
  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildElevatedButton(),
          const SizedBox(
            height: 20,
          ),
          _buildRouteList()
        ],
      ),
    );
  }

  Expanded _buildRouteList() {
    return Expanded(
      child: StreamBuilder(
          stream: routesStore.motionRoutes$,
          builder: (context, AsyncSnapshot<List<MotionRoute>?> routes) {
            if (routes.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (routes.data!.isEmpty) {
              return Text("No routes added");
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: routes.data!.length,
                itemBuilder: (context, index) {
                  return _buildRouteItemContainer(routes, index);
                },
              );
            }
          }),
    );
  }

  Container _buildRouteItemContainer(
      AsyncSnapshot<List<MotionRoute>?> routes, int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Origin: " + routes.data![index].originName!),
                Text("Destination: " + routes.data![index].destinationName!),
                Text("Time: " + routes.data![index].estimatedTravelTime!),
                Text("Distance: " +
                    routes.data![index].estimatedTravelDistance!),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                MapServices.setSelectedRouteAndAnimateToIt(routes.data![index]);
                Navigator.of(context).pop();
              },
              child: Text(
                "Show",
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    );
  }

  ElevatedButton _buildElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      onPressed: () async {
        ReusableWidgets.showLoader(context);
        await GenerateRouteServices().generateNewRoute();
        ReusableWidgets.popLoader();
      },
      child: Text("Generate new route",
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: Text(
        "Routes",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
