import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  bool isPageAffiliate = false;

  void changePageAffiliate({required bool value}){
    if(isPageAffiliate != value){
      isPageAffiliate = value;
      notifyListeners();
    }
  }

}
