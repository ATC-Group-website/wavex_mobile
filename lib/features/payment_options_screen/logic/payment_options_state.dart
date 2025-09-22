part of 'payment_options_cubit.dart';

@immutable
sealed class PaymentOptionsState extends Equatable {
  const PaymentOptionsState();

  @override
  List<Object?> get props => [];
}

final class PaymentOptionsInitial extends PaymentOptionsState {}

final class PurchaseLoadingState extends PaymentOptionsState {}

final class PurchaseSuccessState extends PaymentOptionsState {
  final PurchaseResponse purchaseResponse;
  final String orderId;

  const PurchaseSuccessState({
    required this.purchaseResponse,
    required this.orderId,
  });

  @override
  List<Object?> get props => [purchaseResponse, orderId];
}

final class PurchaseErrorState extends PaymentOptionsState {
  final String error;

  const PurchaseErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
