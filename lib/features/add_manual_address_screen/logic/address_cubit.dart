import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/add_manual_address_screen/data/repository/address_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/address_request_body.dart';
import '../data/models/address_response.dart';
import '../data/models/get_address_byId_response.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressRepository repository;

  AddressCubit(this.repository) : super(AddressInitial());

  static AddressCubit get(context) => BlocProvider.of(context);

  addAddress({required AddressRequestBody address}) {
    emit(AddAddressLoadingState());
    repository
        .addAddress(
      address: address,
    )
        .then((value) {
      print("data: " + value!.data);

      if (value.statusCode == 200 || value.statusCode == 201) {
        emit(
          AddAddressSuccessState(
            addressResponse: AddressResponse.fromJson(
              jsonDecode(value.data),
            ),
          ),
        );
      } else {
        // هنا السيرفر راجع error زي 422
        final errorMsg =
            jsonDecode(value.data)["message"] ?? "Registration failed";
        emit(AddAddressErrorState(error: errorMsg));
      }
    }).catchError((error) {
      print(error.toString());
      emit(AddAddressErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  updateAddress({required int addressId, required AddressRequestBody address}) {
    emit(UpdateAddressLoadingState());
    repository
        .updateAddress(
      addressId: addressId,
      address: address,
    )
        .then((value) {
      print("data: " + value!.data);
      if (value!.statusCode == 200 || value.statusCode == 201) {
        emit(
          UpdateAddressSuccessState(
            addressResponse: AddressResponse.fromJson(
              jsonDecode(value.data),
            ),
          ),
        );
      } else {
        // هنا السيرفر راجع error زي 422
        final errorMsg = jsonDecode(value.data)["message"] ?? "";
        emit(UpdateAddressErrorState(error: errorMsg));
      }
    }).catchError((error) {
      print(error.toString());
      emit(UpdateAddressErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  getAddressById({required int addressId}) {
    emit(GetAddressByIdLoadingState());
    repository
        .getAddressById(
      addressId: addressId,
    )
        .then((value) {
      print("data: " + value!.data);
      if (value!.statusCode == 200 || value.statusCode == 201) {
        emit(
          GetAddressByIdSuccessState(
            addressByIdResponse: GetAddressByIdResponse.fromJson(
              jsonDecode(value.data),
            ),
          ),
        );
      } else {
        // هنا السيرفر راجع error زي 422
        final errorMsg = jsonDecode(value.data)["message"] ?? "";
        emit(GetAddressByIdErrorState(error: errorMsg));
      }
    }).catchError(
      (error) {
        print(error.toString());
        emit(GetAddressByIdErrorState(
          error: error is ApiException ? error.message : error.toString(),
        ));
      },
    );
  }
}
