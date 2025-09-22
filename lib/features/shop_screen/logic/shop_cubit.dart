import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/shop_screen/data/models/get_products_response.dart';
import 'package:wavex/features/shop_screen/data/repository/shop_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/add_to_cart_request_body.dart';
import '../data/models/add_to_cart_response.dart';
import '../data/models/get_categories_response.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopRepository repository;

  ShopCubit(this.repository) : super(ShopInitial());

  static ShopCubit get(context) => BlocProvider.of(context);

  getProducts({
    int? pageNumber,
    String? q,
    double? priceFrom,
    double? priceTo,
    int? category,
    String? sortPrice,
    bool loadMore = false,
  }) {
    if (!loadMore) {
      emit(GetProductsLoadingState());
    }

    repository
        .getProducts(
      pageNumber: pageNumber,
      category: category,
      priceFrom: priceFrom,
      priceTo: priceTo,
      q: q,
      sortPrice: sortPrice,
    )
        .then((value) {
      final response = GetProductsResponse.fromJson(jsonDecode(value!.data));

      final lastPage = response.data?.lastPage ?? 1;

      if (loadMore && state is GetProductsSuccessState) {
        final oldState = state as GetProductsSuccessState;
        final oldProducts = oldState.productsResponse.data?.data ?? [];
        final newProducts = response.data?.data ?? [];

        // merge only if not over last page
        if (pageNumber != null) {
          if (pageNumber <= lastPage) {
            response.data?.data = [...oldProducts, ...newProducts];
          } else {
            // just reuse old state, don’t emit again
            emit(oldState);
            return;
          }
        }
      }

      emit(GetProductsSuccessState(productsResponse: response));
    }).catchError((error) {
      emit(GetProductsErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  getCategories() {
    emit(GetCategoriesLoadingState());
    repository.getCategories().then(
      (value) {
        emit(
          GetCategoriesSuccessState(
            categoriesResponse:
                GetCategoriesResponse.fromJson(jsonDecode(value!.data)),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState(
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
}
