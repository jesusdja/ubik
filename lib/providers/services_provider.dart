import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesProvider extends ChangeNotifier {

  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');

  bool loadDataService = true;
  bool loadDataBusiness = true;

  List<Map<String,dynamic>> dataServices = [];
  List<Map<String,dynamic>> dataBusiness = [];

  ServicesProvider(){
    initialFirebaseListener();
  }

  Future initialFirebaseListener()async{
    categoryCollection.where('isService',isEqualTo: true).snapshots().listen((event) {
      try{
        dataServices = [];
        for (var element in event.docs) {
          Map<String,dynamic> data = element.data() as Map<String,dynamic>;
          if(data['cant'] != 0){
            dataServices.add(data);
          }
        }
      }catch(e){
        debugPrint('Error : ${e.toString()}');
      }

      loadDataService = false;
      notifyListeners();
    });

    categoryCollection.where('isBusiness',isEqualTo: true).snapshots().listen((event) {
      try{
        dataBusiness = [];
        for (var element in event.docs) {
          Map<String,dynamic> data = element.data() as Map<String,dynamic>;
          if(data['cant'] != 0){
            dataBusiness.add(data);
          }
        }
      }catch(e){
        debugPrint('Error : ${e.toString()}');
      }

      loadDataBusiness = false;
      notifyListeners();
    });
  }

}
