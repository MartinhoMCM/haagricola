import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/models/request.dart';


class CRUDModelRequest extends ChangeNotifier
{

  final Firestore _db = Firestore.instance;
  final String path="requests";
  CollectionReference ref;
  List<Request> requests;
  final Function(bool) isError;
  final Function(String) ErrorMessage;


  CRUDModelRequest({this.isError, this.ErrorMessage}){
    ref=_db.collection(path);
  }











  Future<List<Request>> fetchRequest() async
  {
    var result = await ref.getDocuments();
    requests =result.documents .map((doc)=> Request.fromMap(doc.data, doc.documentID)).toList();

    return requests;
  }


  Stream<QuerySnapshot> fetchProductAsStream()
  {
    return ref.snapshots();
  }



  Future<Request> getRequestById(String id) async {
    var doc = await ref.document(id).get();
    return Request.fromMap(doc.data, doc.documentID);

  }

  Future<void> addRequest(Request data ) async{
          await ref.add(data.toJson()).then((value)
          {
            if(value.documentID.length>0)
            {
              debugPrint("DOC ID ${value.documentID} ");
              isError(false);

            }
          }).catchError((error)
          {
           debugPrint("Erro $error");
           isError(true);
           ErrorMessage(error['data']);
          });
  }
  static Future uploadFile(String name, File _file) async{

    StorageReference ref =FirebaseStorage.instance.ref().child('products/$name');
    StorageUploadTask storageUploadTask =ref.putFile(_file);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      debugPrint("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {

      storageUploadTask.events.listen((event) {
        double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
            / event.snapshot.totalByteCount.toDouble());
        debugPrint("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
      String downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      debugPrint("Download URL " + downloadUrl1.toString());

    } else{
      //Catch any cases here that might come up like canceled, interrupted
    }
  }
  static Future<String> uploadFilePreform(String name, File _file) async{

    List<String> str=Helper.DateNow().split(" ");
    List<String> str1=str[1].split(",");

    final formName="${str[0]}_${str1[0]}_${str[2]}";
    List<String> hours=Helper.HourNow().split(':');

    StorageReference ref =FirebaseStorage.instance.ref().child('filepreform/${name}_${formName}_${hours[0]}_${hours[1]}_${hours[2]}');
    StorageUploadTask storageUploadTask =ref.putFile(_file);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      return url;

    } else if (storageUploadTask.isInProgress) {

      storageUploadTask.events.listen((event) {
        double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
            / event.snapshot.totalByteCount.toDouble());
      });

      StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
      String downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.

      return downloadUrl1;
    }
    else
      if(storageUploadTask.isCanceled){
        debugPrint("canceled" );
      }
      else{
    }
    return null;
  }
}

