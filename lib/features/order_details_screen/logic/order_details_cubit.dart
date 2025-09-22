import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/order_details_screen/data/models/order_details_response.dart';
import 'package:wavex/features/order_details_screen/data/repository/orders_details_repository.dart';

import '../../../core/networks/api_exception.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {

  OrdersDetailsRepository repository;
  OrderDetailsCubit(this.repository) : super(OrderDetailsInitial());

  static OrderDetailsCubit get(context) => BlocProvider.of(context);


  getOrders({
    required String orderId
  }){
    emit(GetOrderDetailsLoadingState());

    repository.getOrders(orderId: orderId).then(
          (value) {
        if (value!.statusCode == 200 || value.statusCode == 201) {
          emit(
            GetOrderDetailsSuccessState(
                orderDetailsResponse: OrderDetailsResponse.fromJson(
                  jsonDecode(value.data),
                ),
            ),
          );
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg =
              jsonDecode(value.data)["message"] ?? "Registration failed";
          emit(GetOrderDetailsErrorState(error: errorMsg));
        }
      },
    ).catchError((error) {
      emit(GetOrderDetailsErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

}
