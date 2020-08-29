

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/service/api.dart';
import 'package:flutter/material.dart';
import 'package:ha_angricola/service/locator.dart';

class CRUDModelProduct extends ChangeNotifier
{
  Api _api = locator<Api>();
  List<Product> products;

  Future<List<Product>> fetchProducts() async
  {
    var result = await _api.getDataCollection();
    products =result.documents .map((doc)=> Product.fromMap(doc.data, doc.documentID)).toList();

    return products;
  }


  Stream<QuerySnapshot> fetchProductAsStream()
  {
    return _api.streamDataCollection();
  }
  Stream<QuerySnapshot> fetchProductCategoryAsStream(String category)
  {
    return  _api.streamDataCollectionCategory(category);

  }

  Stream<QuerySnapshot> fetchProductNameAsStream({String productName})
  {
    return _api.streamDataCollectionProductName(productName);
  }


  Future<Product> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Product.fromMap(doc.data, doc.documentID);
  }

 /* Future removeProduct(String id) async
  {
    await _api.removeDocument(id);
    return;
  }*/

  Future updateProduct(Product data, String id) async => await _api.updateDocument(data.toJson(), id);

  Future addProduct(Product data ) async => await _api.addDocument(data.toJson());

}


