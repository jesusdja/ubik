import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/utils/get_data.dart';

class CategoryProvider extends ChangeNotifier {

  Map<String,dynamic> categorySelected = {};
  List<Map<String,dynamic>> dataBusinessAll = [];
  List<Map<String,dynamic>> listUsers = [];
  bool loadDataInitial = true;
  Map<String,dynamic> userSelectedMap = {};
  int indexPage = 0;
  int filterDistance = 0;
  int typeCategory = 1;
  LatLng positionNow = const LatLng(0.0, 0.0);

  Map<String,dynamic> userSelectedDetails = {};

  CategoryProvider(){
    initialFirebaseListener();
  }

  set changeCategory(Map<String,dynamic> value){
    categorySelected = value;
    listUsers = [];
    loadDataInitial = true;
    indexPage = 0;
    notifyListeners();
    refreshPosition();
    getListFilterForCategory();
  }
  set changeLoad(bool value){  loadDataInitial = value; notifyListeners();}
  set changeTypeCategory(int value){  typeCategory = value; notifyListeners();}
  set changeFilterDistance(int value){  filterDistance = value; notifyListeners();}
  set changeUserSelectedMap(Map<String,dynamic> value){  userSelectedMap = value; notifyListeners();}
  set changeUserSelectedDetails(Map<String,dynamic> value){  userSelectedDetails = value; notifyListeners();}
  set changeIndexPage(int value){  indexPage = value; notifyListeners();}
  set listUserForCategory(List<Map<String,dynamic>> value) { dataBusinessAll = value; notifyListeners(); }

  Future initialFirebaseListener() async {

    refreshPosition();

    FirebaseConnectionAffiliates().affiliatesCollection.snapshots().listen((event) {
      try{
        List<Map<String,dynamic>> dataBusinessAux = [];
        for (var element in event.docs) {
          Map<String,dynamic> data = element.data() as Map<String,dynamic>;
          dataBusinessAux.add(data);
        }
        listUserForCategory = dataBusinessAux;
      }catch(e){
        debugPrint('Error : ${e.toString()}');
      }
    });
  }

  Future getListFilterForCategory() async{
    if(categorySelected.isNotEmpty){
      String idSelected = categorySelected['idC'];
      for (var users in dataBusinessAll) {
        if(users['categoryId'] == idSelected){
          listUsers.add(users);
        }
      }
    }
    loadDataInitial = false;
    notifyListeners();
  }

  refreshPosition() async {
    positionNow = await getPositionNow();
    notifyListeners();
  }

}
