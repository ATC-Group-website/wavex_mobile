import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/purchase_response.dart';
import '../data/repository/payment_options_repository.dart';

part 'payment_options_state.dart';

class PaymentOptionsCubit extends Cubit<PaymentOptionsState> {
  PaymentOptionsRepository repository;

  PaymentOptionsCubit(this.repository) : super(PaymentOptionsInitial());

  static PaymentOptionsCubit get(context) => BlocProvider.of(context);

  purchase({required String orderId, required dynamic addressId}) {
    emit(PurchaseLoadingState());

    repository.purchase(orderId: orderId, addressId: addressId).then(
      (value) {
        if (value!.statusCode == 200 || value!.statusCode == 201) {
          emit(
            PurchaseSuccessState(
              purchaseResponse: PurchaseResponse.fromJson(
                jsonDecode(value.data),
              ),
              orderId: orderId
            ),
          );
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg =
              jsonDecode(value.data)["message"] ?? "Registration failed";
          emit(PurchaseErrorState(error: errorMsg));
        }
      },
    ).catchError((error) {
      emit(PurchaseErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
}
