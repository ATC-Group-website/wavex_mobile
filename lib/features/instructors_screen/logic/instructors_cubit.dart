import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/instructors_screen/data/repository/instructors_repository.dart';

import '../../home_screen/data/models/get_instructors_response.dart';
import '../data/models/get_instructor_response.dart';

part 'instructors_state.dart';

class InstructorsCubit extends Cubit<InstructorsState> {
  InstructorsRepository repository;

  InstructorsCubit(this.repository) : super(InstructorsInitial());

  static InstructorsCubit get(context) => BlocProvider.of(context);

  getInstructors() {
    emit(GetInstructorsLoadingState());

    repository.getInstructors().then(
      (value) {
        emit(
          GetInstructorsSuccessState(
            instructorsResponse: GetInstructorsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetInstructorsErrorState(error: error.toString()));
    });
  }

  getInstructor({required int instructorId}) {
    emit(GetInstructorLoadingState());

    repository.getInstructor(instructorId: instructorId).then(
      (value) {
        emit(
          GetInstructorSuccessState(
            instructorResponse: GetInstructorResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetInstructorErrorState(error: error.toString()));
    });
  }
}
