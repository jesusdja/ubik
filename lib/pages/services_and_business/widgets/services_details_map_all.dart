import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/services_and_business/widgets/marker_generator.dart';
import 'package:ubik/providers/category_provider.dart';
import 'package:ubik/utils/get_data.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/google_map_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ServicesDetailsMapAll extends StatefulWidget {
  const ServicesDetailsMapAll({Key? key}) : super(key: key);
  @override
  _ServicesDetailsMapAllState createState() => _ServicesDetailsMapAllState();
}

class _ServicesDetailsMapAllState extends State<ServicesDetailsMapAll> {

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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeH * 0.07),
        child: appBar(),
      ),
      bottomNavigationBar: Container(
        width: sizeW,
        height: sizeH * 0.16,
        padding: EdgeInsets.only(top: sizeH * 0.01,bottom: sizeH * 0.005,left: sizeW * 0.06,right: sizeW * 0.06),
        child: _bottomNavigator(context),
      ),
      body: SizedBox(
        width: sizeW,
        child: GoogleMapsWidget(
          positionInitial: initialCameraPosition,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          myLocationEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerMap = controller;
            setInitialLocation();
            Future<dynamic>.delayed(const Duration(milliseconds: 500)).then((dynamic v) {
              setInitialLocation();
            },);
          },
          markers: markers.toSet(),
        ),
      ),
    );
  }

  Widget _bottomNavigator(BuildContext context){

    Image imageName = ViewImage().netWork(categoryProvider.userSelectedDetails['profile']['photoURL']);

    String affiliateRate = '0.0';
    if(categoryProvider.userSelectedDetails['pointRate'] != null && categoryProvider.userSelectedDetails['pointRate'] != 0.0){
      affiliateRate = (categoryProvider.userSelectedDetails['pointRate'] as double).toStringAsFixed(1);
    }

    return SizedBox(
      width: sizeW,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: sizeW,
            child: Row(
              children: <Widget>[
                avatarCircularImage(border: UbicaColors.grey, radius: sizeH * 0.03, image: imageName),
                SizedBox(width: sizeW * 0.015,),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(categoryProvider.userSelectedDetails['profile']['name'],style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.semiBold),),
                          SizedBox(width: sizeW * 0.015,),
                          Container(
                            width: sizeH * 0.02,
                            height: sizeH * 0.02,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ViewImage().assetsImage('assets/image/icon_full_star_small.png').image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: sizeW * 0.01,),
                          Text(affiliateRate,style: UbicaStyles().stylePrimary(size: sizeH * 0.018, enumStyle: EnumStyle.light),),
                        ],
                      ),
                      SizedBox(height: sizeH * 0.005,),
                      Row(
                        children: <Widget>[
                          containerImageAssets(sizeH * 0.02, sizeH * 0.02,'icon_direccion_profiles.png'),
                          SizedBox(width: sizeW * 0.01,),
                          Text('A ${categoryProvider.userSelectedDetails['distance']} km.',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, enumStyle: EnumStyle.light),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: sizeH * 0.015,),
          SizedBox(
            width: sizeW,
            child: ButtonGeneral(
              title: 'VER EN GOOGLE MAPS',
              onPressed: () {
                if(currentLocation != null){
                  Helpers.launchURL('https://www.google.com/maps/dir/${currentLocation!.latitude!},${currentLocation!.longitude!}/${categoryProvider.userSelectedDetails['placeSelect']['latitude']},${categoryProvider.userSelectedDetails['placeSelect']['longitude']}/@${currentLocation!.latitude!},${currentLocation!.longitude!},15z/data=!4m2!4m1!3e2?hl=es');
                }
              },
              backgroundColor: UbicaColors.primary,
              borderColor: UbicaColors.primary,
              textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018,color: UbicaColors.white,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),
              height: sizeH * 0.045,
              icon: Container(
                width: sizeH * 0.025,
                height: sizeH * 0.025,
                margin: EdgeInsets.only(right: sizeW * 0.02),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/icon_google_maps_button.png').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
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
      if(x == 1){
        lat = categoryProvider.userSelectedDetails['placeSelect']['latitude'];
        lng = categoryProvider.userSelectedDetails['placeSelect']['longitude'];
      }
      if(x == 2){
        lat = currentLocation!.latitude! - 0.0009; //8.2591;
        lng = currentLocation!.longitude! + 0.004; //-62.7702;
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
    listMark.add(_getMarkerWidget(categoryProvider.typeCategory, UbicaColors.color6FCF97));
    //listMark.add(_getMarkerWidget(2, UbicaColors.color_6FCF97));
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
                  ),
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

  Widget appBar(){
    return AppBar(
      backgroundColor: UbicaColors.white,
      title: Text('Mapa',style: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary, enumStyle: EnumStyle.medium),),
      elevation: 10.0,
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.all(sizeH * 0.01),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage().assetsImage('assets/image/icon_back_app-orange.png').image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
