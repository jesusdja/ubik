import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionInvoices{

  final CollectionReference invoicesCollection = FirebaseFirestore.instance.collection('invoices');

  Future<bool> createInvoices(Map<String,dynamic> data) async {
    bool res = false;
    try{
      await invoicesCollection.add(data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<List<QueryDocumentSnapshot>> getAllInvoices() async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await invoicesCollection.get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<List<QueryDocumentSnapshot>> getInvoices({required String id}) async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await invoicesCollection.where('uid',isEqualTo: id).get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<bool> editInvoices({required Map<String, dynamic> data,required String id}) async {
    bool res = false;
    try{
      await invoicesCollection.doc(id).update(data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

}

