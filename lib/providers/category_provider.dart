import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/services/firebase/firebase_connection_invoices.dart';
import 'package:ubik/services/sharedprefereces.dart';
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
          data['id'] = element.id;
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

          //Calcular rango
          List rateAll = users['rate'];
          if(rateAll.isNotEmpty){
            double points = 0.0;
            for (var element in rateAll) {
              try{
                points = points + element['point'];
              }catch(_){}
            }
            users['pointRate'] = points / rateAll.length;
          }
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

  Future<Map<String,dynamic>> contactarAffiliate() async{
    Map<String,dynamic> result = {'error' : true, 'sms' : 'Error de conexión'};
    String uidFirebase = SharedPrefs.prefs.getString('userFirebaseUbik') ?? '';

    try{
      List<QueryDocumentSnapshot> listAll = await FirebaseConnectionInvoices().getInvoices(uid: uidFirebase, idAff: userSelectedDetails['id']);
      bool exists = true;
      for (var element in listAll) {
        Map<String,dynamic> data = element.data() as Map<String,dynamic>;
        if(!data.containsKey('isFinish')){
          exists = false;
        }
      }
      if(exists){
        Map<String,dynamic> data = {
          'id_affiliate' : userSelectedDetails['id'],
          'uid' : uidFirebase,
        };

        bool res = await FirebaseConnectionInvoices().createInvoices(data);
        if(res){
          result = {'error' : false, 'sms' : 'Contactado con exito.!'};
        }else{
          result = {'error' : true, 'sms' : 'Error al crear el ticket de contratación'};
        }
      }else{
        result = {'error' : true, 'sms' : 'Ya existe un ticket abierto con este ${typeCategory == 1 ? 'Servicio' : 'Comercio'}'};
      }
    }catch(_){
      result = {'error' : true, 'sms' : 'Error de conexión con el servidor'};
    }

    return result;
  }

}
