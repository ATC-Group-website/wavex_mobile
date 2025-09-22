import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/home_screen/data/models/get_instructors_response.dart';
import 'package:wavex/features/home_screen/data/models/notifications_response.dart';
import 'package:wavex/features/home_screen/data/repository/home_repository.dart';

import '../../../core/networks/api_exception.dart';
import '../../classes_screen/data/models/get_programs_response.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepository repository;

  HomeCubit(this.repository) : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  getInstructors() {
    emit(GetInstructorsLoadingState());

    repository.getInstructors().then(
      (value) {
        emit(
          GetInstructorsSuccessState(
            instructorsResponse: GetInstructorsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetInstructorsErrorState(error: error.toString()));
    });
  }

  getPrograms() {
    emit(GetProgramsLoadingState());

    repository.getPrograms().then(
      (value) {
        emit(
          GetProgramsSuccessState(
            programsResponse: GetProgramsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetProgramsErrorState(error: error.toString()));
    });
  }

  markNotificationAsRead({required int notificationId}) {
    emit(MarkNotificationAsReadLoadingState());

    repository.markNotificationAsRead(notificationId: notificationId).then(
      (value) {
        emit(
          MarkNotificationAsReadSuccessState(),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(MarkNotificationAsReadErrorState(error: error.toString()));
    });
  }

  int currentPage = 1;
  int lastPage = 1;
  List<NotificationData> allNotifications = [];

  Future<void> getNotification({int pageNumber = 1}) async {
    emit(GetNotificationLoadingState());

    try {
      final value = await repository.getNotification(pageNumber: pageNumber);

      final response = NotificationsResponse.fromJson(
        jsonDecode(value?.data),
      );

      currentPage = response.data?.currentPage ?? 1;
      lastPage = response.data?.lastPage ?? 1;

      if (pageNumber == 1) {
        allNotifications = response.data?.data ?? [];
      } else {
        allNotifications.addAll(response.data?.data ?? []);
      }

      emit(GetNotificationSuccessState(
        notificationsResponse: allNotifications,
        hasMore: currentPage < lastPage,
      ));
    } catch (error) {
      emit(GetNotificationErrorState(
        error: error is ApiException ? error.message : error.toString(),
      ));
    }
  }
}
