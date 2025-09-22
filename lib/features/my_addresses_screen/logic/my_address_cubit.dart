import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/my_addresses_screen/data/models/get_my_addresses.dart';
import 'package:wavex/features/my_addresses_screen/data/repository/my_address_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/delete_address_response.dart';

part 'my_address_state.dart';

class MyAddressCubit extends Cubit<MyAddressState> {
  MyAddressRepository repository;

  MyAddressCubit(this.repository) : super(MyAddressInitial());

  static MyAddressCubit get(context) => BlocProvider.of(context);

  getMyAddress() {
    emit(GetMyAddressesLoadingState());
    repository.getMyAddress().then((value) {
      print("data: " + value!.data);
      emit(
        GetMyAddressesSuccessState(
          myAddressesResponse: GetMyAddressesResponse.fromJson(
            jsonDecode(value.data),
          ),
        ),
      );
    }).catchError((error) {
      print(error.toString());
      emit(
        GetMyAddressesErrorState(
          error: error.toString(),
        ),
      );
    });
  }

  deleteAddress({required int addressId}) {
    emit(DeleteAddressLoadingState());
    repository.deleteAddress(addressId: addressId).then((value) {
      print("data: " + value!.data);
      emit(
        DeleteAddressSuccessState(
          deleteAddressResponse: DeleteAddressResponse.fromJson(
            jsonDecode(value.data),
          ),
        ),
      );
    }).catchError((error) {
      print(error.toString());
      emit(
        DeleteAddressErrorState(
          error: error is ApiException ? error.message : error.toString(),
        ),
      );
    });
  }
}
