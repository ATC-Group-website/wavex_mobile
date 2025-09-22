part of 'programs_cubit.dart';

@immutable
sealed class ProgramsState {}

final class ProgramsInitial extends ProgramsState {}
final class GetProgramsLoadingState extends ProgramsState {}
final class GetProgramsSuccessState extends ProgramsState {
  final GetProgramsResponse programsResponse;

  GetProgramsSuccessState({required this.programsResponse});
}
final class GetProgramsErrorState extends ProgramsState {final String error;

  GetProgramsErrorState({required this.error});}
