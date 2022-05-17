import 'package:flutter/material.dart';
import 'package:ubik/services/sharedprefereces.dart';

Future<void> finishApp() async{
  try{
    SharedPrefs.prefs.remove('emailPleksus');
    debugPrint('TODO LIMPIO');
  }catch(e){
    debugPrint(e.toString());
  }
}