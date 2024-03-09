import 'dart:io';

import 'package:either_dart/either.dart';

import 'package:firebase_storage/firebase_storage.dart';
import '../../core/models/error_model.dart';

class FirebaseImageService {
  final _service = FirebaseStorage.instance.ref();
  final _path = 'products/';

  Future<Either<ErrorModel, String>> uploadImage(
      File file, String barcode) async {
    await _existFile(barcode);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = await _service.child('$_path$barcode.jpg').putFile(
          file,
          metadata,
        );
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    if (downloadUrl.isNotEmpty) {
      return Right(downloadUrl);
    } else {
      return Left(ErrorModel('resim yüklenemedi'));
    }
  }

  Future<void> _existFile(String id) async {
    try {
      await _service.child('$_path$id.jpg').delete();
    } catch (e) {
      return;
    }
  }
}
