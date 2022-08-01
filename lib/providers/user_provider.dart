import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  User? userFirebase;
  bool loadDataUser = true;
  bool isTeacher = false;
  int selectedBottomHome = 1;
  List<String>? listVideos = [];

  bool isPageAffiliate = false;

  UserProvider() {
    userActive();
  }

  Future userActive() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if(event != null){
        userFirebase = event;
        loadDataUser = false;
        notifyListeners();
      }
    });
  }

  Future refreshUser() async{
    userFirebase = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  void changePageAffiliate({required bool value}){
    isPageAffiliate = value;
    notifyListeners();
  }

}
