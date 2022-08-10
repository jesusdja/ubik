import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ubik/services/sharedprefereces.dart';

class AuthenticateFirebaseUser{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Map<String,dynamic>> registerFirebase({required String email, required String password, required String alias, required String urlPhoto})async{
    Map<String,dynamic> data = {};
    try{
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user!.updateDisplayName(alias);
      await userCredential.user!.updatePhotoURL(urlPhoto);
      data['user'] = userCredential.user;
      SharedPrefs.prefs.setBool('ubikLogin',false);
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

  Future<Map<String,dynamic>> signInFirebase({required String email, required String password})async{
    Map<String,dynamic> data = {};
    try{
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      data['user'] = userCredential.user;
      SharedPrefs.prefs.setBool('ubikLogin',false);
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

  Future<Map<String,dynamic>> signOutFirebase()async{
    Map<String,dynamic> data = {};
    try{
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

  Future<Map<String,dynamic>> sendPasswordResetEmailFirebase({required String email})async{
    Map<String,dynamic> data = {};
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

  Future<Map<String,dynamic>> confirmPasswordResetFirebase({required String newPass, required String code})async{
    Map<String,dynamic> data = {};
    try{
      await firebaseAuth.confirmPasswordReset(newPassword: newPass,code: code);
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

  Future<Map<String,dynamic>> editFirebaseUser({required User userCredential, String name = '', String pass = '', String pass2 = '', String pathImage = ''})async{
    Map<String,dynamic> data = {};
    try{
      if(name.isNotEmpty){
        await userCredential.updateDisplayName(name);
      }
      if(pass.isNotEmpty && pass2.isNotEmpty && pass != pass2){
        await userCredential.updatePassword(pass2);
      }
      if(pathImage.isNotEmpty){
        String name = pathImage.split('/').last;
        final pathUpload = 'files/$name';
        final file = File(pathImage);
        final ref = FirebaseStorage.instance.ref().child(pathUpload);
        UploadTask uploadTask = ref.putFile(file);
        final snapshot = await uploadTask;
        final urlUpload = await snapshot.ref.getDownloadURL();
        await userCredential.updatePhotoURL(urlUpload);
      }
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
      data['error'] = e.code;
    }
    return data;
  }

}