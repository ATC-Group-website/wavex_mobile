import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart';
import 'package:wavex/features/classes_screen/data/repository/programs_repository.dart';
import 'package:wavex/features/shop_screen/data/models/get_products_response.dart';

part 'programs_state.dart';

class ProgramsCubit extends Cubit<ProgramsState> {
  ProgramsRepository repository;
  ProgramsCubit(this.repository) : super(ProgramsInitial());

  static ProgramsCubit get(context) => BlocProvider.of(context);

  getPrograms() {
    emit(GetProgramsLoadingState());

    repository.getPrograms().then(
          (value) {
        emit(
          GetProgramsSuccessState(
            programsResponse: GetProgramsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetProgramsErrorState(error: error.toString()));
    });
  }
}
