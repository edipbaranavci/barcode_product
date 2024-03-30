// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_product_cubit.dart';

class SearchProductState extends Equatable {
  const SearchProductState({
    required this.productModelList,
    this.searchProductModelList,
  });

  final List<ProductModel> productModelList;
  final List<ProductModel>? searchProductModelList;

  @override
  List<Object> get props => [
        productModelList,
        searchProductModelList ?? [],
      ];

  SearchProductState copyWith({
    List<ProductModel>? productModelList,
    List<ProductModel>? searchProductModelList,
  }) {
    return SearchProductState(
      productModelList: productModelList ?? this.productModelList,
      searchProductModelList:
          searchProductModelList ?? this.searchProductModelList,
    );
  }
}
