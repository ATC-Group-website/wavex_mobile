part of 'update_user_data_cubit.dart';

@immutable
sealed class UpdateUserDataState {}

final class UpdateUserDataInitial extends UpdateUserDataState {}
final class UpdateUserDataLoadingState extends UpdateUserDataState {}
final class UpdateUserDataSuccessState extends UpdateUserDataState {
  final UpdateUserDataResponse userDataResponse;

  UpdateUserDataSuccessState({required this.userDataResponse});
}
final class UpdateUserDataErrorState extends UpdateUserDataState {
  final String error;

  UpdateUserDataErrorState({required this.error});
}

final class UserProfileDataLoadingState extends UpdateUserDataState {}
final class UserProfileDataSuccessState extends UpdateUserDataState {
  final UserProfileResponse userProfileResponse;

  UserProfileDataSuccessState({required this.userProfileResponse});
}
final class UserProfileDataErrorState extends UpdateUserDataState {
  final String error;

  UserProfileDataErrorState({required this.error});
}
