// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_cubit.dart';

class AddProductState extends Equatable {
  const AddProductState({
    this.selectedImage,
    this.uloadedImageUrl,
    this.isDone = false,
  });

  final File? selectedImage;
  final String? uloadedImageUrl;
  final bool isDone;

  @override
  List<Object> get props => [
        selectedImage ?? File,
        uloadedImageUrl ?? '',
        isDone,
      ];

  AddProductState copyWith({
    File? selectedImage,
    String? uloadedImageUrl,
    bool? isDone,
  }) {
    return AddProductState(
      selectedImage: selectedImage ?? this.selectedImage,
      uloadedImageUrl: uloadedImageUrl ?? this.uloadedImageUrl,
      isDone: isDone ?? this.isDone,
    );
  }
}

final class AddProductInitial extends AddProductState {}
