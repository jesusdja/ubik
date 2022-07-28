import 'package:flutter/material.dart';
import 'package:ubik/services/authenticate_firebase.dart';
import 'package:ubik/services/sharedprefereces.dart';

Future<void> finishApp() async{
  try{
    await AuthenticateFirebaseUser().signOutFirebase();
    SharedPrefs.prefs.remove('ubikLogin');
    SharedPrefs.prefs.remove('userFirebaseUbik');
    debugPrint('TODO LIMPIO');
  }catch(e){
    debugPrint(e.toString());
  }
}