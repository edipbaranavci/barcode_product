// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.productModelList,
    this.searchProductModelList,
  });

  final List<ProductModel>? productModelList;
  final List<ProductModel>? searchProductModelList;

  @override
  List<Object> get props => [
        productModelList ?? [],
        searchProductModelList ?? [],
      ];

  HomeState copyWith({
    List<ProductModel>? productModelList,
    List<ProductModel>? searchProductModelList,
  }) {
    return HomeState(
      productModelList: productModelList ?? this.productModelList,
      searchProductModelList:
          searchProductModelList ?? this.searchProductModelList,
    );
  }
}

final class HomeInitial extends HomeState {}
