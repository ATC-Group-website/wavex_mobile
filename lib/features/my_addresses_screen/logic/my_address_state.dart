part of 'my_address_cubit.dart';

@immutable
sealed class MyAddressState {}

final class MyAddressInitial extends MyAddressState {}
final class GetMyAddressesLoadingState extends MyAddressState {}
final class GetMyAddressesSuccessState extends MyAddressState {
  final GetMyAddressesResponse myAddressesResponse;

  GetMyAddressesSuccessState({required this.myAddressesResponse});
}
final class GetMyAddressesErrorState extends MyAddressState {
  final String error;

  GetMyAddressesErrorState({required this.error});
}

final class DeleteAddressLoadingState extends MyAddressState {}
final class DeleteAddressSuccessState extends MyAddressState {
  final DeleteAddressResponse deleteAddressResponse;

  DeleteAddressSuccessState({required this.deleteAddressResponse});
}
final class DeleteAddressErrorState extends MyAddressState {
  final String error;

  DeleteAddressErrorState({required this.error});
}
