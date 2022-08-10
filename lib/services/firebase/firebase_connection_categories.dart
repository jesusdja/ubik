import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionCategories{

  final CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('category');

  Future<List<QueryDocumentSnapshot>> getAllCategories() async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await categoriesCollection.get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

}

