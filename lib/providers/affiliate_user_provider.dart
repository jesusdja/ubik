import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubik/services/firebase/firebase_connection_categories.dart';

class AffiliateUserProvider extends ChangeNotifier {

  int pageAffiliate = 0;
  Map<String, dynamic> placeSelect = {};
  List<String> photos = ['','','','',];
  String name = '';
  String prePhone = '';
  String phone = '';
  String description = '';
  Map<String,dynamic> categorySelected = {};
  List<Map<String,dynamic>> listCategories = [];

  void dataInitial(){
    photos = ['','','','',];
    name = '';
    prePhone = '';
    phone = '';
    description = '';
    categorySelected = {};
    pageAffiliate = 0;
    listCategories = [];
    getCategories();
  }

  Map<String,dynamic> toMap(){
    return {
      'placeSelect' : placeSelect,
      'name' : name,
      'prePhone' : prePhone,
      'phone' : phone,
      'description' : description,
    };
  }

  void changeName({required String value}){ name = value; notifyListeners(); }
  void changePrePhone({required String value}){ prePhone = value; notifyListeners(); }
  void changePhone({required String value}){ phone = value; notifyListeners(); }
  void changePhotos({required List<String> value}){ photos = value; notifyListeners(); }
  void changePage({required int value}){ pageAffiliate = value; notifyListeners(); }
  void changePlace({required Map<String, dynamic> value}){ placeSelect = value; notifyListeners(); }
  void changeDescription({required String value}){ description = value; notifyListeners(); }
  void changeIdCategory({required Map<String,dynamic> value}){ categorySelected = value; notifyListeners(); }

  Future getCategories() async{
    List<QueryDocumentSnapshot> data = await FirebaseConnectionCategories().getAllCategories();
    for (var element in data) {
      listCategories.add(element.data() as Map<String,dynamic>);
    }
    notifyListeners();
  }
}
