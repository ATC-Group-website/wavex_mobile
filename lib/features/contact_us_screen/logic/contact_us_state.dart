part of 'contact_us_cubit.dart';

@immutable
sealed class ContactUsState {}

final class ContactUsInitial extends ContactUsState {}
final class ContactUsLoadingState extends ContactUsState {}
final class ContactUsSuccessState extends ContactUsState {
  final ContactUsResponse contactUsResponse;

  ContactUsSuccessState({required this.contactUsResponse});
}
final class ContactUsErrorState extends ContactUsState {
  final String error;

  ContactUsErrorState({required this.error});
}

final class GetSocialLinksLoadingState extends ContactUsState {}
final class GetSocialLinksSuccessState extends ContactUsState {
  final SocialLinksResponse socialLinksResponse;

  GetSocialLinksSuccessState({required this.socialLinksResponse});
}
final class GetSocialLinksErrorState extends ContactUsState {
  final String error;

  GetSocialLinksErrorState({required this.error});
}

final class GetTopicsLoadingState extends ContactUsState {}
final class GetTopicsSuccessState extends ContactUsState {
  final TopicsResponse topicsResponse;

  GetTopicsSuccessState({required this.topicsResponse});
}
final class GetTopicsErrorState extends ContactUsState {
  final String error;

  GetTopicsErrorState({required this.error});
}
