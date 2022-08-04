import 'package:flutter/material.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';

class ServicesProvider extends ChangeNotifier {

  bool loadDataService = true;
  bool loadDataBusiness = true;

  List<Map<String,dynamic>> dataServices = [];
  List<Map<String,dynamic>> dataBusiness = [];

  ServicesProvider(){
    initialFirebaseListener();
  }

  Future initialFirebaseListener()async{
    FirebaseConnectionAffiliates().affiliatesCollection.where('isService',isEqualTo: true).snapshots().listen((event) {
      try{
        for (var element in event.docs) {
          Map<String,dynamic> data = element.data() as Map<String,dynamic>;
          dataServices.add(data);
        }
      }catch(e){
        debugPrint('Error : ${e.toString()}');
      }

      loadDataService = false;
      notifyListeners();
    });

    FirebaseConnectionAffiliates().affiliatesCollection.where('isBusiness',isEqualTo: true).snapshots().listen((event) {
      try{
        for (var element in event.docs) {
          Map<String,dynamic> data = element.data() as Map<String,dynamic>;
          dataBusiness.add(data);
        }
      }catch(e){
        debugPrint('Error : ${e.toString()}');
      }

      loadDataBusiness = false;
      notifyListeners();
    });
  }

}
