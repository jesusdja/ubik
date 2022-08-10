
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

enum affiliateStatus {
  wait,
  processing,
  accepted,
  denied,
  warned,
}

Map<affiliateStatus,String> mapStAffiliateStatus = {
  affiliateStatus.wait : 'wait',
  affiliateStatus.processing : 'processing',
  affiliateStatus.accepted : 'accepted',
  affiliateStatus.denied : 'denied',
  affiliateStatus.warned : 'warned',
};

Map<String,List<String>> getDataCountries(){
  Map<String,List<String>> dataInfoCodigoMarcado = {};
  dataInfoCodigoMarcado[''] = ["","","","",""];
  dataInfoCodigoMarcado['ARG'] = ["Argentina","+54","14","10","11"];
  dataInfoCodigoMarcado['CHL'] = ["Chile","+56","50","8","9"];
  dataInfoCodigoMarcado['COL'] = ["Colombia","+57","54","10","10"];
  dataInfoCodigoMarcado['CRI'] = ["Costa Rica","+506","59","8","8"];
  dataInfoCodigoMarcado['CUB'] = ["Cuba","+53","1","8","8"];
  dataInfoCodigoMarcado['ECU'] = ["Ecuador","+593","70","9","10"];
  dataInfoCodigoMarcado['USA'] = ["Estados Unidos","+1","237","10","10"];
  dataInfoCodigoMarcado['ESP'] = ["España","+34","210","9","9"];
  dataInfoCodigoMarcado['GTM'] = ["Guatemala","+502","96","8","8"];
  dataInfoCodigoMarcado['HND'] = ["Honduras","+504","101","8","8"];
  dataInfoCodigoMarcado['MEX'] = ["México","+52","153","10","10"];
  dataInfoCodigoMarcado['PER'] = ["Perú","+51","186","9","9"];
  dataInfoCodigoMarcado['VEN'] = ["Venezuela","+58","241","10","10"];
  return dataInfoCodigoMarcado;
}

String getDistanceTwoPoints(LatLng yourPos, LatLng mePos){
  double distance = 0;
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((yourPos.latitude - mePos.latitude) * p)/2 +
      c(mePos.latitude * p) * c(yourPos.latitude * p) *
          (1 - c((yourPos.longitude - mePos.longitude) * p))/2;
  distance = 12742 * asin(sqrt(a));
  return distance.toStringAsFixed(2);
}

Future<LatLng> getPositionNow() async{
  Location location = Location();
  LocationData currentLocation = await location.getLocation();
  return LatLng(currentLocation.latitude!, currentLocation.longitude!);
}

class Helpers {
  static void launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}