import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/orders_screen/data/models/get_orders_response.dart';
import 'package:wavex/features/orders_screen/data/repository/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersRepository repository;

  OrdersCubit(this.repository) : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  getOrders() {
    emit(GetOrdersLoadingState());

    repository.getOrders().then(
      (value) {
        emit(
          GetOrdersSuccessState(
            ordersResponse: GetOrdersResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetOrdersErrorState(error: error.toString()));
    });
  }
}
