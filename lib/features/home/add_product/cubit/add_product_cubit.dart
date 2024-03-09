import 'dart:io';

import 'package:barcode_products/core/models/product/product_model.dart';
import 'package:barcode_products/features/service/firebase_firestore_service.dart';

import '../../../../core/extensions/scaffold_messenger/snack_bar.dart';
import '../../../service/firebase_image_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final countController = TextEditingController();
  final categoryController = TextEditingController();

  final _imageService = FirebaseImageService();
  final _firebaseFirestoreService = FirebaseFirestoreService();
  void scanBarcode(String value) {
    barcodeController.text = value;
  }

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (image != null) {
      emit(state.copyWith(selectedImage: File(image.path)));
    }
  }

  Future<void> uploadImage() async {
    final res = await _imageService.uploadImage(
      File(state.selectedImage!.path),
      barcodeController.text,
    );
    res.fold(
      (left) => scaffoldKey.showErrorSnackBar(left.errorMessage),
      (right) {
        emit(state.copyWith(uloadedImageUrl: right));
      },
    );
  }

  Future<void> uploadProduct() async {
    if (state.selectedImage == null) {
      scaffoldKey.showErrorSnackBar('Lütfen bir resim seçin!');
      return;
    } else {
      await uploadImage().whenComplete(() async {
        final model = ProductModel(
          barcode: barcodeController.text,
          category: categoryController.text,
          count: int.parse(countController.text),
          name: nameController.text,
          photoUrl: state.uloadedImageUrl,
          price: priceController.text,
        );

        final res = await _firebaseFirestoreService.addProduct(model);
        if (res) {
          scaffoldKey.showGreatSnackBar('Ürün Yüklendi!');
          emit(state.copyWith(isDone: true));
        } else {
          scaffoldKey.showErrorSnackBar('Bir Hata Var!');
        }
      });
    }
  }
}
