part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}
final class GetOrdersLoadingState extends OrdersState {}
final class GetOrdersSuccessState extends OrdersState {
 final GetOrdersResponse ordersResponse;

  GetOrdersSuccessState({required this.ordersResponse});
}
final class GetOrdersErrorState extends OrdersState {
  final String error;

  GetOrdersErrorState({required this.error});
}
