import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/google_map_widget.dart';
import 'package:ubik/widgets_utils/map_marker.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';

class DialogShowMap extends StatefulWidget {
  const DialogShowMap({Key? key}) : super(key: key);

  @override
  State<DialogShowMap> createState() => _DialogShowMapState();
}

class _DialogShowMapState extends State<DialogShowMap> {

  GoogleMapController? _controllerMap;
  location_package.LocationData? currentLocation;
  location_package.Location location = location_package.Location();
  final Set<Marker> _markers = <Marker>{};
  TextEditingController cllSearch = TextEditingController();
  bool addressSearch = false;
  Map<String, dynamic> placeSelect = {};

  double zoomMap = 20.0;
  bool loadMap = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cllSearch.dispose();

  }

  Future<void> setInitialLocation() async {
    currentLocation = await location.getLocation();
    if(currentLocation != null){
      LatLng latLng = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      _updateMarker(latLng.latitude, latLng.longitude);
      if (currentLocation != null && _controllerMap != null) {
        _controllerMap!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: zoomMap,
            ),
          ),
        );
        await searchPlace(
          latLng.latitude,
          latLng.longitude,
        );
      }
    }
    loadMap = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {



    const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 1.0,
    );

    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: sizeW,
            child: Text('Busca tu dirección :',style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.semiBold),textAlign: TextAlign.left,),
          ),
          SizedBox(height: sizeH * 0.005,),
          searchButton(),
          SizedBox(height: sizeH * 0.02,),
          _mapDialog(initialCameraPosition, size),
          SizedBox(height: sizeH * 0.02,),
          textAddresses(),
          SizedBox(height: sizeH * 0.02,),
          saveButton(),
        ],
      ),
    );
  }

  Widget textAddresses(){

    if(placeSelect.isEmpty) { return Container(); }

    String name = placeSelect['name'];
    double lat = placeSelect['latitude'] as double;
    double lg = placeSelect['longitude'] as double;
    String country = placeSelect['country'];
    String state = placeSelect['state'];
    String city = placeSelect['city'];

    return Container(
      width: sizeW,
      child: Text(
        '$country, $state, $city, $name ($lat-$lg)',
        style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.regular),
      ),
    );
  }

  Widget searchButton() {

    return Container();
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(5),
    //     color: Colors.grey[200],
    //     border: Border.all(
    //       color: Colors.grey[200]!,
    //       width: 1.5,
    //       style: BorderStyle.solid,
    //     ),
    //   ),
    //   child: GooglePlaceAutoCompleteTextField(
    //     textEditingController: cllSearch,
    //     textStyle: UbicaStyles().styleSemiBold(sizeH * 0.02),
    //     googleAPIKey: 'AIzaSyCEuJI-CifdQVODUboAC7tppnAj2wgwkJE',
    //     inputDecoration: InputDecoration(
    //       prefixIcon: Icon(
    //         Icons.search,
    //         color: UbicaColors.black,
    //       ),
    //       border: InputBorder.none,
    //       alignLabelWithHint: true,
    //       suffixIcon: InkWell(
    //         onTap: (){
    //           cllSearch.clear();
    //           cllSearch.text = '';
    //           placeSelect = null;
    //           setState(() {});
    //         },
    //         child: Icon(
    //           Icons.delete,
    //           color: UbicaColors.black,
    //         ),
    //       )
    //     ),
    //     itmClick: (Prediction prediction) async {
    //       addressSearch = true;
    //       setState(() {});
    //
    //       Placemark pos;
    //       Location location;
    //       try {
    //         final locations = await locationFromAddress(prediction.description);
    //         location = locations.first;
    //         pos = (await placemarkFromCoordinates(location.latitude, location.longitude))?.first;
    //       } catch (_) {}
    //       if (pos != null) {
    //         cllSearch.text = prediction.description;
    //         cllSearch.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length,));
    //         _updateMarker(location.latitude, location.longitude);
    //         placeSelect = <String, dynamic>{};
    //         placeSelect['name'] = prediction.description;
    //         placeSelect['latitude'] = location.latitude;
    //         placeSelect['longitude'] = location.longitude;
    //         placeSelect['country'] = 'Pais';
    //         placeSelect['state'] = 'Estado';
    //         placeSelect['city'] = 'Ciudad';
    //
    //         List<Placemark> placemark;
    //         try {
    //           placemark = await placemarkFromCoordinates(location.latitude, location.longitude);
    //           placeSelect['country'] = placemark[0].country ?? 'Pais';
    //           placeSelect['state'] = placemark[0].administrativeArea ?? 'Estado';
    //           placeSelect['city'] = placemark[0].locality ?? 'Ciudad';
    //         } catch (_) {}
    //
    //         addressSearch = false;
    //         setState(() {});
    //       }
    //     },
    //   ),
    // );
  }

  Widget _mapDialog(CameraPosition initialCameraPosition, Size size) {
    return SizedBox(
      width: sizeW,
      height: sizeH * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            GoogleMapsWidget(
              positionInitial: initialCameraPosition,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                _controllerMap = controller;
                setInitialLocation();
              },
              markers: _markers,
              onTap: (LatLng latLng) async {
                await searchPlace(latLng.latitude, latLng.longitude);
                _updateMarker(latLng.latitude, latLng.longitude);
              },
            ),
            loadMap ? Container(
              width: sizeW,
              height: sizeH * 0.4,
              color: Colors.grey[200],
              child: Center(
                child: circularProgressColors(
                  colorCircular: UbicaColors.primary
                ),
              ),
            ) : Container(),
          ],
        )
      ),
    );
  }

  Future<void> _updateMarker(double lat, double lng) async {
    if(mounted){
      setState(() {
        _markers.remove('Marker');
      });
    }
    _markers.add(
      Marker(
        draggable: true,
        markerId: const MarkerId('Marker'),
        position: LatLng(lat, lng),
        onDragEnd: (value) async {
          await searchPlace(
            value.latitude,
            value.longitude,
          );
        },
      ),
    );

    // var image = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
    //   size: Size(sizeH * 0.1, sizeH * 0.1),
    // ),"assets/image/icon_map_place_profile_2.png",);
    //
    // final Uint8List markerIcon = await getBytesFromAsset('assets/images/icon_map_place_profile_2.png', 300);
    //
    //
    // _markers.add(
    //   Marker(
    //     draggable: true,
    //     markerId: const MarkerId('Marker'),
    //     position: LatLng(lat, lng),
    //     icon: BitmapDescriptor.fromBytes(markerIcon),
    //     onDragEnd: (value) async {
    //       await searchPlace(
    //         value.latitude,
    //         value.longitude,
    //       );
    //     },
    //   ),
    // );
    //
    // setState(() {});

    try{
      if(mounted){
        _controllerMap!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: zoomMap),
          ),
        );
      }
    }catch(_){}

  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> searchPlace(double latitude, double longitude) async {
    addressSearch = true;
    placeSelect = {};
    cllSearch.text = '';

    List<Placemark> placemark = [];
    try {
      placemark = await placemarkFromCoordinates(latitude,longitude,);
    } catch (_) {}

    if (placemark.isNotEmpty) {
      final String name = formatNameAddress(placemark[0]);
      cllSearch.text = name;
      placeSelect = <String, dynamic>{};
      placeSelect['name'] = name;
      placeSelect['latitude'] = latitude;
      placeSelect['longitude'] = longitude;
      placeSelect['country'] = placemark[0].country ?? 'Pais';
      placeSelect['state'] = placemark[0].administrativeArea ?? 'Estado';
      placeSelect['city'] = placemark[0].locality ?? 'Ciudad';
    }

    addressSearch = false;
    if(mounted){
      setState(() {});
    }
  }

  String formatNameAddress(Placemark place) {
    String name = '';
    try {
      name += place.thoroughfare!;
      name += ', ${place.subThoroughfare}';
      name += ', ${place.locality}';
      name = name.replaceAll('Unnamed Road', ' ');
      name = name.replaceAll(',  ', '');
      name = name.replaceAll(' , ', '');
    } catch (_) {}
    return name;
  }

  Widget saveButton() {
    return addressSearch ?
    const CircularProgressIndicator()
        :
    placeSelect.isEmpty ?
    Container()
        :
    InkWell(
      child: Container(
        width: sizeW * 0.3,
        height: sizeH * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: UbicaColors.primary,
          border: Border.all(
            color: UbicaColors.primary,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text('AGREGAR',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, color: UbicaColors.white, enumStyle: EnumStyle.medium)),
        ),
      ),
      onTap: (){


        if(placeSelect.isNotEmpty){
          AffiliateUserProvider affiliateUserProvider = Provider.of<AffiliateUserProvider>(context, listen: false);
          affiliateUserProvider.changePlace(value: placeSelect);
          affiliateUserProvider.changePage(value: 2);
        }else{
          showAlert(text: 'Debe seleccionar otro punto en el mapa', isError: true);
        }
      },
    );
  }
}
