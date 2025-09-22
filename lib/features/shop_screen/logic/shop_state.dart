
part of 'shop_cubit.dart';


@immutable
sealed class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

final class ShopInitial extends ShopState {}

final class GetProductsLoadingState extends ShopState {}

final class GetProductsSuccessState extends ShopState {
  final GetProductsResponse productsResponse;

  const GetProductsSuccessState({required this.productsResponse});

  @override
  List<Object?> get props => [productsResponse];
}

final class GetProductsErrorState extends ShopState {
  final String error;

  const GetProductsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

final class GetCategoriesLoadingState extends ShopState {}

final class GetCategoriesSuccessState extends ShopState {
  final GetCategoriesResponse categoriesResponse;

  const GetCategoriesSuccessState({required this.categoriesResponse});

  @override
  List<Object?> get props => [categoriesResponse];
}

final class GetCategoriesErrorState extends ShopState {
  final String error;

  const GetCategoriesErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

final class AddToCartLoadingState extends ShopState {}

final class AddToCartSuccessState extends ShopState {
  final AddToCartResponse addToCartResponse;

  const AddToCartSuccessState({required this.addToCartResponse});

  @override
  List<Object?> get props => [addToCartResponse];
}

final class AddToCartErrorState extends ShopState {
  final String error;

  const AddToCartErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
