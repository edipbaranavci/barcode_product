import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/product/product_model.dart';

part 'search_product_state.dart';

class SearchProductCubit extends Cubit<SearchProductState> {
  SearchProductCubit(this.productModelList)
      : super(SearchProductState(productModelList: productModelList));
  final List<ProductModel> productModelList;

  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productBarcodeController = TextEditingController();

  void searchWithBarcodeProduct(String barcodeId) {
    productBarcodeController.text = barcodeId;
    final oldList = state.productModelList;
    final List<ProductModel> newList = [];

    for (var element in oldList) {
      if (element.barcode == barcodeId) {
        newList.add(element);
      }
    }
    emit(state.copyWith(searchProductModelList: newList));
  }

  void searchWithNamedProduct() {
    final newName = productNameController.text.toLowerCase();
    final oldList = state.productModelList;
    final List<ProductModel> newList = [];

    for (var element in oldList) {
      final oldName = (element.name ?? '').toLowerCase();
      final value = oldName.contains(newName);
      if (value) {
        newList.add(element);
      }
    }
    emit(state.copyWith(searchProductModelList: newList));
  }

  void clearSearchProductModelList() {
    emit(state.copyWith(searchProductModelList: []));
    productBarcodeController.clear();
    productNameController.clear();
  }
}
