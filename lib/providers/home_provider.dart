import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  bool isPageAffiliate = false;

  void changePageAffiliate({required bool value}){
    isPageAffiliate = value;
    notifyListeners();
  }

}
