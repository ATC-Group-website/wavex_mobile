part of 'registration_cubit.dart';

@immutable
sealed class RegistrationState {}

final class RegistrationInitial extends RegistrationState {}
final class RegistrationLoadingState extends RegistrationState {}
final class RegistrationSuccessState extends RegistrationState {
  final RegisterResponse registerResponse;

  RegistrationSuccessState({required this.registerResponse});
}
final class RegistrationErrorState extends RegistrationState {
  final String? error;

  RegistrationErrorState({required this.error});
}
