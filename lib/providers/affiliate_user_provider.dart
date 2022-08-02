import 'package:flutter/material.dart';

class AffiliateUserProvider extends ChangeNotifier {

  int pageAffiliate = 0;
  Map<String, dynamic> placeSelect = {};
  List<String> photos = ['','','','',];
  String name = '';
  String prePhone = '';
  String phone = '';

  void dataInitial(){
    photos = ['','','','',];
    name = '';
    prePhone = '';
    phone = '';
    pageAffiliate = 0;
  }

  void changeName({required String value}){ name = value; notifyListeners(); }
  void changePrePhone({required String value}){ prePhone = value; notifyListeners(); }
  void changePhone({required String value}){ phone = value; notifyListeners(); }
  void changePhotos({required List<String> value}){ photos = value; notifyListeners(); }
  void changePage({required int value}){ pageAffiliate = value; notifyListeners(); }
  void changePlace({required Map<String, dynamic> value}){ placeSelect = value; notifyListeners(); }
}
