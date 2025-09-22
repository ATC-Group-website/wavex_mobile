import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/shop_cart_screen/data/models/get_cart_response.dart';
import 'package:wavex/features/shop_cart_screen/data/repository/shop_cart_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../../orders_screen/data/models/get_orders_response.dart';
import '../../shop_screen/data/models/add_to_cart_request_body.dart';
import '../../shop_screen/data/models/add_to_cart_response.dart';

part 'shop_cart_state.dart';

class ShopCartCubit extends Cubit<ShopCartState> {
  ShopCartRepository repository;

  ShopCartCubit(this.repository) : super(ShopCartInitial());

  static ShopCartCubit get(context) => BlocProvider.of(context);

  getCart({String? orderId}) {
    emit(GetCartLoadingState());

    repository.getCart(orderId: orderId).then(
      (value) {
        emit(
          GetCartSuccessState(
            cartResponse: GetCartResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetCartErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  addToCart({required AddToCartRequestBody addToCartRequestBody}) {
    emit(AddToCartLoadingState());
    repository.addToCart(addToCartRequestBody: addToCartRequestBody).then(
      (value) {
        if (value!.statusCode == 200 || value.statusCode == 201) {
          emit(AddToCartSuccessState(
            addToCartResponse:
                AddToCartResponse.fromJson(jsonDecode(value!.data)),
          ));
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg = jsonDecode(value.data)["message"] ?? "";
          emit(AddToCartErrorState(error: errorMsg));
        }
      },
    ).catchError((error) {
      print(error.toString());
      emit(AddToCartErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  decreaseQuantity({required int orderItemId,required bool isFromDecrease}) {
    emit(DecreaseItemLoadingState());
    repository.decreaseQuantity(orderItemId: orderItemId).then(
      (value) {
        if (value!.statusCode == 200 || value.statusCode == 201) {
          emit(DecreaseItemSuccessState(isFromDecrease: isFromDecrease));
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg = jsonDecode(value.data)["message"] ?? "";
          emit(DecreaseItemErrorState(error: errorMsg));
        }
      },
    ).catchError((error) {
      print(error.toString());
      emit(DecreaseItemErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
}
