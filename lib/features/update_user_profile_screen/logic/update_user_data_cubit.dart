import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/update_user_profile_screen/data/models/user_profile_response.dart';
import 'package:wavex/features/update_user_profile_screen/data/repository/update_user_profile_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/update_user_data_response.dart';

part 'update_user_data_state.dart';

class UpdateUserDataCubit extends Cubit<UpdateUserDataState> {
  UpdateUserProfileRepository repository;

  UpdateUserDataCubit(this.repository) : super(UpdateUserDataInitial());

  static UpdateUserDataCubit get(context) => BlocProvider.of(context);

  updateUserData({
    String? phone,
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? medical,    String? emergencyNumber,

    String? gender,
  }) {
    emit(UpdateUserDataLoadingState());

    repository
        .updateUserData(
            phone: phone,
            email: email,
            lastName: lastName,emergencyNumber: emergencyNumber,
            firstName: firstName,
      gender: gender,dateOfBirth: dateOfBirth,medical: medical
    )
        .then(
      (value) {
        emit(
          UpdateUserDataSuccessState(
            userDataResponse: UpdateUserDataResponse.fromJson(
              jsonDecode(value?.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      emit(UpdateUserDataErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  getUserProfileData() {
    emit(UserProfileDataLoadingState());

    repository
        .getUserProfileData()
        .then(
      (value) {
        emit(
          UserProfileDataSuccessState(
            userProfileResponse: UserProfileResponse.fromJson(
              jsonDecode(value?.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      emit(UserProfileDataErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
}
