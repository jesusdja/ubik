import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationPackage;

class DialogShowMap extends StatefulWidget {
  const DialogShowMap({Key? key}) : super(key: key);

  @override
  State<DialogShowMap> createState() => _DialogShowMapState();
}

class _DialogShowMapState extends State<DialogShowMap> {

  GoogleMapController _controllerMap;
  locationPackage.LocationData currentLocation;
  locationPackage.Location location;
  final Set<Marker> _markers = <Marker>{};
  TextEditingController cllSearch;
  bool addressSearch = false;
  Map<String, dynamic> placeSelect;

  double sizeH = 0;
  double sizeW = 0;
  double zoomMap = 20.0;

  @override
  void initState() {
    //TODO: Initial location must be the previously selected one
    location = locationPackage.Location();
    cllSearch = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cllSearch.dispose();

  }

  Future<void> setInitialLocation() async {
    currentLocation = await location.getLocation();

    _updateMarker(currentLocation.latitude, currentLocation.longitude);
    if (currentLocation != null && _controllerMap != null) {
      _controllerMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: zoomMap,
          ),
        ),
      );
      await searchPlace(
        currentLocation.latitude,
        currentLocation.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    sizeH = MediaQuery.of(context).size.height;
    sizeW = MediaQuery.of(context).size.width;

    const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 1.0,
    );

    final Size size = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: sizeW,
              child: Text('Busca tu dirección :',style: UbicaStyles().styleSemiBold(sizeH * 0.02),textAlign: TextAlign.left,),
            ),
            SizedBox(height: sizeH * 0.005,),
            searchButton(),
            SizedBox(height: sizeH * 0.02,),
            _mapDialog(initialCameraPosition, size),
            SizedBox(height: sizeH * 0.02,),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget searchButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.grey[200],
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: cllSearch,
        textStyle: UbicaStyles().styleSemiBold(sizeH * 0.02),
        googleAPIKey: 'AIzaSyCEuJI-CifdQVODUboAC7tppnAj2wgwkJE',
        inputDecoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: UbicaColors.black,
          ),
          border: InputBorder.none,
          alignLabelWithHint: true,
          suffixIcon: InkWell(
            onTap: (){
              cllSearch.clear();
              cllSearch.text = '';
              placeSelect = null;
              setState(() {});
            },
            child: Icon(
              Icons.delete,
              color: UbicaColors.black,
            ),
          )
        ),
        itmClick: (Prediction prediction) async {
          addressSearch = true;
          setState(() {});

          Placemark pos;
          Location location;
          try {
            final locations = await locationFromAddress(prediction.description);
            location = locations.first;
            pos = (await placemarkFromCoordinates(location.latitude, location.longitude))?.first;
          } catch (_) {}
          if (pos != null) {
            cllSearch.text = prediction.description;
            cllSearch.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length,));
            _updateMarker(location.latitude, location.longitude);
            placeSelect = <String, dynamic>{};
            placeSelect['name'] = prediction.description;
            placeSelect['latitude'] = location.latitude;
            placeSelect['longitude'] = location.longitude;
            placeSelect['country'] = 'Pais';
            placeSelect['state'] = 'Estado';
            placeSelect['city'] = 'Ciudad';

            List<Placemark> placemark;
            try {
              placemark = await placemarkFromCoordinates(location.latitude, location.longitude);
              placeSelect['country'] = placemark[0].country ?? 'Pais';
              placeSelect['state'] = placemark[0].administrativeArea ?? 'Estado';
              placeSelect['city'] = placemark[0].locality ?? 'Ciudad';
            } catch (_) {}

            addressSearch = false;
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _mapDialog(CameraPosition initialCameraPosition, Size size) {
    return Container(
      width: sizeW,
      height: sizeH * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: GoogleMapsWidget(
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
        markerId: MarkerId('Marker'),
        position: LatLng(lat, lng),
        onDragEnd: (value) async {
          await searchPlace(
            value.latitude,
            value.longitude,
          );
        },
      ),
    );

    try{
      if(mounted){
        _controllerMap.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: zoomMap),
          ),
        );
      }
    }catch(_){}

  }

  Future<void> searchPlace(double latitude, double longitude) async {
    addressSearch = true;
    placeSelect = null;
    cllSearch.text = '';

    List<Placemark> placemark;
    try {
      placemark = await placemarkFromCoordinates(latitude,longitude,);
    } catch (_) {}

    if (placemark != null && placemark.isNotEmpty) {
      final String name = formatNameAddress(placemark[0]);
      cllSearch.text = name;
      placeSelect = <String, dynamic>{};
      placeSelect['name'] = name;
      placeSelect['latitude'] = latitude;
      placeSelect['longitude'] = longitude;
      placeSelect['country'] = 'Pais';
      placeSelect['state'] = 'Estado';
      placeSelect['city'] = 'Ciudad';

      if(placemark[0] != null){
        placeSelect['country'] = placemark[0].country ?? 'Pais';
        placeSelect['state'] = placemark[0].administrativeArea ?? 'Estado';
        placeSelect['city'] = placemark[0].locality ?? 'Ciudad';
      }
    }

    addressSearch = false;
    if(mounted){
      setState(() {});
    }
  }

  String formatNameAddress(Placemark place) {
    String name = '';
    try {
      name += place.thoroughfare;
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
    CircularProgressIndicator()
        :
    placeSelect == null ?
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
          child: Text('AGREGAR',style: UbicaStyles().styleMedium(sizeH * 0.018, color: UbicaColors.white)),
        ),
      ),
      onTap: (){
        if(placeSelect['name'] != null && placeSelect['name'] != '' &&
            placeSelect['latitude'] != null && placeSelect['latitude'] != '' &&
            placeSelect['longitude'] != null && placeSelect['longitude'] != '' &&
            placeSelect['country'] != null && placeSelect['country'] != '' &&
            placeSelect['city'] != null && placeSelect['city'] != '' &&
            placeSelect['state'] != null && placeSelect['state'] != ''){
          context.bloc<AffiliateBloc>()..add(AffiliateEvent.updatePlaceSelect(placeSelect));
          context.bloc<AffiliateBloc>()..add(AffiliateEvent.updateFace(2));
        }else{
          showError(context, 'Debe ser mas especifico con la dirección.');
        }
      },
    );
  }
}
