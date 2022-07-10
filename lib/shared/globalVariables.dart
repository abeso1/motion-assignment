import 'dart:async';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Completer<GoogleMapController> completer = Completer();
GoogleMapController? mapController;
String mapKey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');
