part of 'order_details_cubit.dart';

@immutable
sealed class OrderDetailsState {}

final class OrderDetailsInitial extends OrderDetailsState {}



final class GetOrderDetailsLoadingState extends OrderDetailsState {}

final class GetOrderDetailsSuccessState extends OrderDetailsState {
  final OrderDetailsResponse orderDetailsResponse;

  GetOrderDetailsSuccessState({required this.orderDetailsResponse,});
}

final class GetOrderDetailsErrorState extends OrderDetailsState {
  final String error;

  GetOrderDetailsErrorState({required this.error});
}
