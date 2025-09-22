import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/auth/registration_screen/data/models/register_response.dart';
import 'package:wavex/features/auth/registration_screen/data/repository/registration_repository.dart';

import '../../../../core/networks/api_exception.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationRepository repository;

  RegistrationCubit(this.repository) : super(RegistrationInitial());

  static RegistrationCubit get(context) => BlocProvider.of(context);

  register({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String password,
    required String dateOfBirth, // ex: "2025-08-16"
    String? phone,
    String? emergencyNumber,
    String? deviceToken,
    String? medicalConditions,
    String? image,
  }) {
    emit(RegistrationLoadingState());
    repository
        .register(
      email: email,
      password: password,
      dateOfBirth: dateOfBirth,
      firstName: firstName,
      gender: gender,
      medicalConditions: medicalConditions,
      lastName: lastName,
      image: image,
      deviceToken: deviceToken,
      emergencyNumber: emergencyNumber,
      phone: phone,
    )
        .then((value) {
      print("data: " + value!.data);

      if (value.statusCode == 200 || value.statusCode == 201) {
        emit(
          RegistrationSuccessState(
            registerResponse: RegisterResponse.fromJson(
              jsonDecode(value.data),
            ),
          ),
        );
      } else {
        // هنا السيرفر راجع error زي 422
        final errorMsg = jsonDecode(value.data)["message"] ?? "Registration failed";
        emit(RegistrationErrorState(error: errorMsg));
      }
    }).catchError((error) {
      print(error.toString());
      emit(RegistrationErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
}
