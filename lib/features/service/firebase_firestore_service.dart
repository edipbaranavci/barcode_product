import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/models/product/product_model.dart';

class FirebaseFirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final _collectionName = 'products';

  Future<bool> addProduct(ProductModel productModel) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(productModel.barcode)
          .set(productModel.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editProduct(ProductModel productModel) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(productModel.barcode)
          .update(productModel.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
