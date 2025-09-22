part of 'address_cubit.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}
final class AddAddressLoadingState extends AddressState {}
final class AddAddressSuccessState extends AddressState {
  final AddressResponse addressResponse;

  AddAddressSuccessState({required this.addressResponse});
}
final class AddAddressErrorState extends AddressState {
  final String error;

  AddAddressErrorState({required this.error});
}
final class UpdateAddressLoadingState extends AddressState {}
final class UpdateAddressSuccessState extends AddressState {
  final AddressResponse addressResponse;

  UpdateAddressSuccessState({required this.addressResponse});
}
final class UpdateAddressErrorState extends AddressState {
  final String error;

  UpdateAddressErrorState({required this.error});
}


final class GetAddressByIdLoadingState extends AddressState {}
final class GetAddressByIdSuccessState extends AddressState {
  final GetAddressByIdResponse addressByIdResponse;

  GetAddressByIdSuccessState({required this.addressByIdResponse});
}
final class GetAddressByIdErrorState extends AddressState {
  final String error;

  GetAddressByIdErrorState({required this.error});
}

