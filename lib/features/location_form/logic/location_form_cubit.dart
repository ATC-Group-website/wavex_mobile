import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/location_form_request.dart';
import '../data/repository/location_form_repository.dart';

part 'location_form_state.dart';

class LocationFormCubit extends Cubit<LocationFormState> {
  LocationFormCubit(this.repository) : super(const LocationFormInitial());

  final LocationFormRepository repository;

  Future<void> submit(LocationFormRequest request) async {
    emit(const LocationFormSubmitting());
    try {
      emit(LocationFormSuccess(await repository.submit(request)));
    } catch (error) {
      emit(LocationFormFailure(
          error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
