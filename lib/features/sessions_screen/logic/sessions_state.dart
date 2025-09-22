part of 'sessions_cubit.dart';

@immutable
sealed class SessionsState {}

final class SessionsInitial extends SessionsState {}
final class GetSessionsLoadingState extends SessionsState {}
final class GetSessionsSuccessState extends SessionsState {
 final MySessionsResponse sessionsResponse;

  GetSessionsSuccessState({required this.sessionsResponse});
}
final class GetSessionsErrorState extends SessionsState {
  final String error;

  GetSessionsErrorState({required this.error});
}
final class GetRefundReasonsLoadingState extends SessionsState {}
final class GetRefundReasonsSuccessState extends SessionsState {
 final RefundReasonsResponse reasonsResponse;

 GetRefundReasonsSuccessState({required this.reasonsResponse});
}
final class GetRefundReasonsErrorState extends SessionsState {
  final String error;

  GetRefundReasonsErrorState({required this.error});
}

final class MakeRefundLoadingState extends SessionsState {}
final class MakeRefundSuccessState extends SessionsState {
 final RefundResponse refundResponse;

 MakeRefundSuccessState({required this.refundResponse});
}
final class MakeRefundErrorState extends SessionsState {
  final String error;

  MakeRefundErrorState({required this.error});
}

final class CancelSessionLoadingState extends SessionsState {}
final class CancelSessionSuccessState extends SessionsState {
 final RefundResponse refundResponse;

 CancelSessionSuccessState({required this.refundResponse});
}
final class CancelSessionErrorState extends SessionsState {
  final String error;

  CancelSessionErrorState({required this.error});
}
