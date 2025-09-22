import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/sessions_screen/data/models/get_sessions_response.dart';
import 'package:wavex/features/sessions_screen/data/repository/sessions_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../data/models/my_sessions_response.dart';
import '../data/models/refund_reasons_response.dart';
import '../data/models/refund_response.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsRepository repository;

  SessionsCubit(this.repository) : super(SessionsInitial());

  static SessionsCubit get(context) => BlocProvider.of(context);

  getSessions({int? page}) {
    emit(GetSessionsLoadingState());
    repository.getSessions(page: page).then(
      (value) {
        emit(
          GetSessionsSuccessState(
            sessionsResponse: MySessionsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      emit(GetSessionsErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  getReasons() {
    emit(GetRefundReasonsLoadingState());

    repository.getReasons().then(
      (value) {
        emit(
          GetRefundReasonsSuccessState(
            reasonsResponse: RefundReasonsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      emit(GetRefundReasonsErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }

  makeRefund({
    required int sessionId,
    required String reason,
  }) {
    emit(MakeRefundLoadingState());

    repository.makeRefund(sessionId: sessionId, reason: reason).then(
      (value) {
        if (value!.statusCode == 200 || value.statusCode == 201) {
          emit(
            MakeRefundSuccessState(
              refundResponse: RefundResponse.fromJson(
                jsonDecode(value.data),
              ),
            ),
          );
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg = jsonDecode(value.data)["message"] ?? "";
          emit(MakeRefundErrorState(error: errorMsg));
        }

      },
    ).catchError((error) {
      emit(MakeRefundErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
  cancelSession({
    required int sessionId,
    required String reason,
  }) {
    emit(CancelSessionLoadingState());

    repository.cancelSession(sessionId: sessionId, reason: reason).then(
      (value) {
        if (value!.statusCode == 200 || value.statusCode == 201) {
          emit(
            CancelSessionSuccessState(
              refundResponse: RefundResponse.fromJson(
                jsonDecode(value.data),
              ),
            ),
          );
        } else {
          // هنا السيرفر راجع error زي 422
          final errorMsg = jsonDecode(value.data)["message"] ?? "";
          emit(CancelSessionErrorState(error: errorMsg));
        }

      },
    ).catchError((error) {
      emit(CancelSessionErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    });
  }
}
