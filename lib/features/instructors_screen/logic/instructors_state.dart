part of 'instructors_cubit.dart';

@immutable
sealed class InstructorsState {}

final class InstructorsInitial extends InstructorsState {}

final class GetInstructorsLoadingState extends InstructorsState {}

final class GetInstructorsSuccessState extends InstructorsState {
  final GetInstructorsResponse instructorsResponse;

  GetInstructorsSuccessState({required this.instructorsResponse});
}

final class GetInstructorsErrorState extends InstructorsState {
  final String error;

  GetInstructorsErrorState({required this.error});
}

final class GetInstructorLoadingState extends InstructorsState {}

final class GetInstructorSuccessState extends InstructorsState {
  final GetInstructorResponse instructorResponse;

  GetInstructorSuccessState({required this.instructorResponse});
}

final class GetInstructorErrorState extends InstructorsState {
  final String error;

  GetInstructorErrorState({required this.error});
}
