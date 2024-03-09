import 'package:equatable/equatable.dart';

class ProductModel with EquatableMixin {
  String? name;
  int? count;
  String? category;
  String? barcode;
  String? price;
  String? photoUrl;

  ProductModel({
    this.name,
    this.count,
    this.category,
    this.barcode,
    this.price,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [name, count, category, barcode, price, photoUrl];

  ProductModel copyWith({
    String? name,
    int? count,
    String? category,
    String? barcode,
    String? price,
    String? photoUrl,
  }) {
    return ProductModel(
      name: name ?? this.name,
      count: count ?? this.count,
      category: category ?? this.category,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'category': category,
      'barcode': barcode,
      'price': price,
      'photoUrl': photoUrl,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String?,
      count: json['count'] as int?,
      category: json['category'] as String?,
      barcode: json['barcode'] as String?,
      price: json['price'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}
