import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/services_and_business/widgets/marker_generator.dart';
import 'package:ubik/providers/category_provider.dart';
import 'package:ubik/widgets_utils/google_map_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _controllerMap;
  late CategoryProvider categoryProvider;
  LocationData? currentLocation;
  Location location = Location();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 1.0,
    );
    return SizedBox(
      height: sizeH * 0.6,
      width: sizeW,
      child: GoogleMapsWidget(
        positionInitial: initialCameraPosition,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controllerMap = controller;
          setInitialLocation();
          Future<dynamic>.delayed(const Duration(milliseconds: 1000)).then((dynamic v) {
            setInitialLocation();
          },);
        },
        markers: markers.toSet(),
        onTap: (LatLng latLng) {
          //TODO CHANGE
          // router.Router.navigator.pushNamed(router.Router.servicesDetailsMapAll,
          //     arguments: router.ServicesDetailsMapAllArguments(
          //       typeCategory: widget.typeCate,
          //       affiliate: widget.affiliate,
          //       distance: widget.distance,
          //       servicesAffiliate: widget.servicesAffiliate
          //     ));
        },
      ),
    );
  }

  Future<void> setInitialLocation() async {
    currentLocation = await location.getLocation();
    if (currentLocation != null) {
      addWidgetsToMap();
      _controllerMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 17.0,
          ),
        ),
      );
    }
    setState(() {});
  }

  void addWidgetsToMap() {
    MarkerGenerator(_getListMarker(),(bitmaps) {
        setState(
              () {
            markers = mapBitmapsToMarkers(bitmaps);
            _controllerMap.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList(markers), 100));
          },
        );
      },
    ).generate(context);
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    final List<Marker> markersList = [];
    int x = 0;
    bitmaps.asMap().forEach((i, bmp) {
      double lat = currentLocation!.latitude!;
      double lng = currentLocation!.longitude!;
      if(x != 0){
        lat = categoryProvider.userSelectedDetails['placeSelect']['latitude'];
        lng = categoryProvider.userSelectedDetails['placeSelect']['longitude'];
      }
      markersList.add(
        Marker(
          markerId: MarkerId('Marker$x'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: (){}
        ),
      );
      x++;
    },
    );
    return markersList;
  }

  LatLngBounds boundsFromLatLngList(List<Marker> _markers) {
    final List<LatLng> boundsLatLng = [];
    for (var element in _markers) {
      boundsLatLng.add(element.position);
    }

    double? x0, x1, y0, y1;
    for (final LatLng latLng in boundsLatLng) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  List<Widget> _getListMarker(){
    List<Widget> listMark = [];
    listMark.add(_getMarkerWidget(0, UbicaColors.primary));
    listMark.add(_getMarkerWidget(1, UbicaColors.color6FCF97));
    return listMark;
  }

  Widget _getMarkerWidget(int type, Color color) {
    String imagePath = 'icon_map_my_user.png';
    if(type != 0){
      return SizedBox(
        width: sizeW * 0.1,
        height: sizeH * 0.1,
        child: Stack(
          children: <Widget>[
            Container(
              width: sizeW * 0.1,
              height: sizeH * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage().assetsImage('assets/image/icon_map_place_profile2.png').image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: sizeH * 0.013),
                width: sizeH * 0.04,
                height: sizeH * 0.04,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(
                      image: ViewImage().netWork(categoryProvider.userSelectedDetails['profile']['photoURL']).image,
                      fit: BoxFit.fill,
                    )
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container(
      width: sizeW * 0.1,
      height: sizeH * 0.1,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/$imagePath').image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
