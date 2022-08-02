import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatelessWidget {
  final Function(GoogleMapController controller) onMapCreated;
  final CameraPosition positionInitial;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool myLocationEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final Set<Marker> markers;
  final Function(LatLng latLng)? onTap;

  const GoogleMapsWidget({Key? key,
    required this.onMapCreated,
    required this.positionInitial,
    this.myLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.rotateGesturesEnabled = false,
    this.scrollGesturesEnabled = false,
    this.markers = const <Marker>{},
    this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: positionInitial,
      myLocationEnabled: myLocationEnabled,
      rotateGesturesEnabled: rotateGesturesEnabled,
      scrollGesturesEnabled: scrollGesturesEnabled,
      myLocationButtonEnabled: myLocationButtonEnabled,
      zoomControlsEnabled: zoomControlsEnabled,
      zoomGesturesEnabled: zoomGesturesEnabled,
      onMapCreated: onMapCreated,
      markers: markers,
      onTap: onTap,
    );
  }
}
