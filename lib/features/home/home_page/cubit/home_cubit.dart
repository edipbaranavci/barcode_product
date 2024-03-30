import 'package:barcode_products/core/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    _init();
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> _init() async {
    await getProductList();
  }

  void changeProductModelList(List<ProductModel> productModelList) {
    emit(state.copyWith(productModelList: productModelList));
  }

  Future<void> getProductList() async {
    List<ProductModel> list = [];
    emit(state.copyWith(productModelList: list, searchProductModelList: list));
    await productsCollection.get().then((value) {
      for (var element in value.docs) {
        list.add(ProductModel.fromJson(element.data() as Map<String, dynamic>));
      }
    });
    emit(state.copyWith(productModelList: list));
  }
}
