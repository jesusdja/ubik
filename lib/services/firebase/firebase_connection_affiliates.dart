import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionAffiliates{

  final CollectionReference affiliatesCollection = FirebaseFirestore.instance.collection('affiliates');

  Future<bool> createAffiliate(Map<String,dynamic> data) async {
    bool res = false;
    try{
      await affiliatesCollection.add(data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<List<QueryDocumentSnapshot>> getAllAffiliates() async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await affiliatesCollection.get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<List<QueryDocumentSnapshot>> getAffiliate({required String id}) async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await affiliatesCollection.where('uid',isEqualTo: id).get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<Map<String,dynamic>> getAffiliateDoc({required String id}) async{
    Map<String,dynamic> listAll = {};
    try{
      var result =  await affiliatesCollection.doc(id).get();
      return result.data() as Map<String,dynamic>;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<bool> editAffiliate({required Map<String, dynamic> data,required String id}) async {
    bool res = false;
    try{
      await affiliatesCollection.doc(id).update(data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

}

