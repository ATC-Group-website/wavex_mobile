part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class GetInstructorsLoadingState extends HomeState {}

final class GetInstructorsSuccessState extends HomeState {
  final GetInstructorsResponse instructorsResponse;

  GetInstructorsSuccessState({required this.instructorsResponse});
}

final class GetInstructorsErrorState extends HomeState {
  final String error;

  GetInstructorsErrorState({required this.error});
}

final class GetProgramsLoadingState extends HomeState {}

final class GetProgramsSuccessState extends HomeState {
  final GetProgramsResponse programsResponse;

  GetProgramsSuccessState({required this.programsResponse});
}

final class GetProgramsErrorState extends HomeState {
  final String error;

  GetProgramsErrorState({required this.error});
}final class MarkNotificationAsReadLoadingState extends HomeState {}

final class MarkNotificationAsReadSuccessState extends HomeState {
}

final class MarkNotificationAsReadErrorState extends HomeState {
  final String error;

  MarkNotificationAsReadErrorState({required this.error});
}

final class GetNotificationLoadingState extends HomeState {}

final class GetNotificationSuccessState extends HomeState {
  final List<NotificationData> notificationsResponse;
  final bool hasMore;

  GetNotificationSuccessState({required this.notificationsResponse,required this.hasMore});
}

final class GetNotificationErrorState extends HomeState {
  final String error;

  GetNotificationErrorState({required this.error});
}
