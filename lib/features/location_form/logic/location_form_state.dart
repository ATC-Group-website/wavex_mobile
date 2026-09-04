part of 'location_form_cubit.dart';

sealed class LocationFormState {
  const LocationFormState();
}

class LocationFormInitial extends LocationFormState {
  const LocationFormInitial();
}

class LocationFormSubmitting extends LocationFormState {
  const LocationFormSubmitting();
}

class LocationFormSuccess extends LocationFormState {
  const LocationFormSuccess(this.message);
  final String message;
}

class LocationFormFailure extends LocationFormState {
  const LocationFormFailure(this.message);
  final String message;
}
