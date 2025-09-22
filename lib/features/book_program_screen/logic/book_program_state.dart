part of 'book_program_cubit.dart';

@immutable
sealed class BookProgramState {}

final class BookProgramInitial extends BookProgramState {}

final class GetProgramByIdLoadingState extends BookProgramState {}

final class GetProgramByIdSuccessState extends BookProgramState {
  final GetProgramByIdResponse programByIdResponse;

  GetProgramByIdSuccessState({required this.programByIdResponse});
}

final class GetProgramByIdErrorState extends BookProgramState {
  final String error;

  GetProgramByIdErrorState({required this.error});
}

final class GetLocationsLoadingState extends BookProgramState {}

final class GetLocationsSuccessState extends BookProgramState {
  final GetLocationsResponse locationsResponse;

  GetLocationsSuccessState({required this.locationsResponse});
}

final class GetLocationsErrorState extends BookProgramState {
  final String error;

  GetLocationsErrorState({required this.error});
}

final class GetSessionsLoadingState extends BookProgramState {}

final class GetSessionsSuccessState extends BookProgramState {
  final GetSessionsResponse sessionsResponse;

  GetSessionsSuccessState({required this.sessionsResponse});
}

final class GetSessionsErrorState extends BookProgramState {
  final String error;

  GetSessionsErrorState({required this.error});
}

final class PaymentLoadingState extends BookProgramState {}

final class PaymentSuccessState extends BookProgramState {
  final PaymentResponse paymentResponse;
  final int sessionId;

  PaymentSuccessState({required this.paymentResponse,required this.sessionId});
}

final class PaymentErrorState extends BookProgramState {
  final String error;

  PaymentErrorState({required this.error});
}

final class BookFreeSessionLoadingState extends BookProgramState {}

final class BookFreeSessionSuccessState extends BookProgramState {
  final BookFreeSessionResponse bookFreeSessionResponse;
  final int sessionId;

  BookFreeSessionSuccessState({required this.bookFreeSessionResponse,required this.sessionId});
}

final class BookFreeSessionErrorState extends BookProgramState {
  final String error;

  BookFreeSessionErrorState({required this.error});
}
