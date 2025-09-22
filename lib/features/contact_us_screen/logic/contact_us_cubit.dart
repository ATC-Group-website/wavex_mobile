import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/contact_us_screen/data/models/contact_us_response.dart';
import 'package:wavex/features/contact_us_screen/data/models/social_links_response.dart';
import 'package:wavex/features/contact_us_screen/data/repository/contact_us_repository.dart';

import '../data/models/topics_response.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsRepository repository;

  ContactUsCubit(this.repository) : super(ContactUsInitial());

  static ContactUsCubit get(context) => BlocProvider.of(context);

  contactUs({
    required String name,
    required String email,
    required String phone,
    required String body,
     String? topic,
    required bool isSubscribedToEmails,
  }) {
    emit(ContactUsLoadingState());

    repository
        .contactUs(
      name: name,
      email: email,
      phone: phone,
      topic: topic,
      body: body,
      isSubscribedToEmails: isSubscribedToEmails,
    )
        .then(
      (value) {
        emit(
          ContactUsSuccessState(
            contactUsResponse: ContactUsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(ContactUsErrorState(error: error.toString()));
    });
  }

  socialLinks() {
    emit(GetSocialLinksLoadingState());

    repository.socialLinks().then(
      (value) {
        emit(
          GetSocialLinksSuccessState(
            socialLinksResponse: SocialLinksResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetSocialLinksErrorState(error: error.toString()));
    });
  }
  getTopics() {
    emit(GetTopicsLoadingState());

    repository.getTopics().then(
      (value) {
        emit(
          GetTopicsSuccessState(
            topicsResponse: TopicsResponse.fromJson(
              jsonDecode(value!.data),
            ),
          ),
        );
      },
    ).catchError((error) {
      print(error.toString());
      emit(GetTopicsErrorState(error: error.toString()));
    });
  }
}
