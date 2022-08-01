import 'package:flutter/material.dart';

class AffiliateUserProvider extends ChangeNotifier {

  List<String> photos = ['','','','',];
  String name = '';
  String prePhone = '';
  String phone = '';

  void dataInitial(){
    photos = ['','','','',];
    name = '';
    prePhone = '';
    phone = '';
  }

  void changeName({required String value}){ name = value; notifyListeners(); }
  void changePrePhone({required String value}){ prePhone = value; notifyListeners(); }
  void changePhone({required String value}){ phone = value; notifyListeners(); }
  void changePhotos({required List<String> value}){ photos = value; notifyListeners(); }
}
