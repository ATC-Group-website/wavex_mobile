part of 'shop_cart_cubit.dart';

@immutable
sealed class ShopCartState {}

final class ShopCartInitial extends ShopCartState {}

final class GetCartLoadingState extends ShopCartState {}

final class GetCartSuccessState extends ShopCartState {
  final GetCartResponse cartResponse;

  GetCartSuccessState({required this.cartResponse});
}

final class GetCartErrorState extends ShopCartState {
  final String error;

  GetCartErrorState({required this.error});
}



final class AddToCartLoadingState extends ShopCartState {}

final class AddToCartSuccessState extends ShopCartState {
  final AddToCartResponse addToCartResponse;

  AddToCartSuccessState({required this.addToCartResponse});
}

final class AddToCartErrorState extends ShopCartState {
  final String error;

  AddToCartErrorState({required this.error});
}

final class DecreaseItemLoadingState extends ShopCartState {}

final class DecreaseItemSuccessState extends ShopCartState {

  final bool isFromDecrease;

  DecreaseItemSuccessState({required this.isFromDecrease});
}

final class DecreaseItemErrorState extends ShopCartState {
  final String error;

  DecreaseItemErrorState({required this.error});
}
