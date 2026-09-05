import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/book_program_screen/data/models/get_locations_response.dart';
import 'package:wavex/features/book_program_screen/data/models/get_program_by_id_response.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart'
    as programs;

import '../../../core/networks/api_exception.dart';
import '../../sessions_screen/data/models/get_sessions_response.dart';
import '../data/models/book_free_session_response.dart';
import '../data/models/payment_response.dart';
import '../data/repository/book_programs_repository.dart';

part 'book_program_state.dart';

class BookProgramCubit extends Cubit<BookProgramState> {
  BookProgramsRepository repository;

  BookProgramCubit(this.repository) : super(BookProgramInitial());

  static BookProgramCubit get(context) => BlocProvider.of(context);

  static String newIdempotencyKey() {
    final random = Random.secure();
    String part(int length) => List.generate(
      length,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    const variants = ['8', '9', 'a', 'b'];
    return '${part(8)}-${part(4)}-4${part(3)}-'
        '${variants[random.nextInt(variants.length)]}${part(3)}-${part(12)}';
  }

  getProgramById({required int id}) {
    emit(GetProgramByIdLoadingState());

    repository
        .getProgramById(id: id)
        .then((value) {
          if (value!.statusCode == 200 || value.statusCode == 201) {
            emit(
              GetProgramByIdSuccessState(
                programByIdResponse: GetProgramByIdResponse.fromJson(
                  jsonDecode(value.data),
                ),
              ),
            );
          } else {
            // هنا السيرفر راجع error زي 422
            final errorMsg = jsonDecode(value.data)["message"] ?? "";
            emit(GetProgramByIdErrorState(error: errorMsg));
          }
        })
        .catchError((error) {
          print(error.toString());
          emit(GetProgramByIdErrorState(error: error.toString()));
        });
  }

  getLocations() {
    emit(GetLocationsLoadingState());

    repository
        .getLocations()
        .then((value) {
          emit(
            GetLocationsSuccessState(
              locationsResponse: GetLocationsResponse.fromJson(
                jsonDecode(value!.data),
              ),
            ),
          );
        })
        .catchError((error) {
          print(error.toString());
          emit(GetLocationsErrorState(error: error.toString()));
        });
  }

  getPrograms() {
    emit(GetProgramsLoadingState());

    repository
        .getPrograms()
        .then((value) {
          if (value == null) {
            emit(GetProgramsErrorState(error: ""));
            return;
          }
          emit(
            GetProgramsSuccessState(
              programsResponse: programs.GetProgramsResponse.fromJson(
                jsonDecode(value.data),
              ),
            ),
          );
        })
        .catchError((error) {
          print(error.toString());
          emit(GetProgramsErrorState(error: error.toString()));
        });
  }

  payment({required int sessionId, required String idempotencyKey}) {
    emit(PaymentLoadingState());

    repository
        .payment(sessionId: sessionId, idempotencyKey: idempotencyKey)
        .then((value) {
          if (value!.statusCode == 200 || value.statusCode == 201) {
            emit(
              PaymentSuccessState(
                paymentResponse: PaymentResponse.fromJson(
                  jsonDecode(value.data),
                ),
                sessionId: sessionId,
              ),
            );
          } else {
            // هنا السيرفر راجع error زي 422
            final errorMsg =
                jsonDecode(value.data)["message"] ?? "Registration failed";
            emit(PaymentErrorState(error: errorMsg));
          }
        })
        .catchError((error) {
          emit(
            PaymentErrorState(
              error: error is ApiException ? error.message : error.toString(),
            ),
          );
        });
  }

  Future<dynamic> paymentStatus({required int paymentId}) {
    return repository.paymentStatus(paymentId: paymentId);
  }

  bookFreeSession({required int sessionId}) {
    emit(BookFreeSessionLoadingState());

    repository
        .bookFreeSession(sessionId: sessionId)
        .then((value) {
          if (value!.statusCode == 200 || value.statusCode == 201) {
            emit(
              BookFreeSessionSuccessState(
                bookFreeSessionResponse: BookFreeSessionResponse.fromJson(
                  jsonDecode(value.data),
                ),
                sessionId: sessionId,
              ),
            );
          } else {
            // هنا السيرفر راجع error زي 422
            final errorMsg =
                jsonDecode(value.data)["message"] ?? "Registration failed";
            emit(BookFreeSessionErrorState(error: errorMsg));
          }
        })
        .catchError((error) {
          emit(
            BookFreeSessionErrorState(
              error: error is ApiException ? error.message : error.toString(),
            ),
          );
        });
  }

  getSessions({required String date, int? programId, int? locationId}) {
    emit(GetSessionsLoadingState());

    repository
        .getSessions(date: date, locationId: locationId, programId: programId)
        .then((value) {
          if (value!.statusCode == 200 || value.statusCode == 201) {
            emit(
              GetSessionsSuccessState(
                sessionsResponse: GetSessionsResponse.fromJson(
                  jsonDecode(value.data),
                ),
              ),
            );
          } else {
            // هنا السيرفر راجع error زي 422
            final errorMsg = jsonDecode(value.data)["message"] ?? "";
            emit(GetSessionsErrorState(error: errorMsg));
          }
        })
        .catchError((error) {
          print(error.toString());
          emit(GetSessionsErrorState(error: error.toString()));
        });
  }
}
