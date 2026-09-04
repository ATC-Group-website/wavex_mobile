// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:school_livechat_app/core/app_cubit/app_cubit.dart';
// import 'package:school_livechat_app/features/auth/presentation/screen/login_screen.dart';
// import 'package:school_livechat_app/features/get_incidents_screen/business_logic/get_incidents_cubit.dart';
// import 'package:school_livechat_app/features/issue_child_exit_card_request_screen/business_logic/get_appointments_cubit.dart';
// import 'package:school_livechat_app/features/notification_screen/data/repository/notification_repository.dart';
// import 'package:school_livechat_app/features/notification_screen/logic/notification_cubit.dart';
// import 'package:school_livechat_app/features/request_contacts_number_screen/business_logic/request_contacts_number_cubit.dart';
// import 'package:school_livechat_app/features/splash_screen/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wavex/core/di/dependency_injection.dart';
import 'package:wavex/features/auth/password_reset_screen/logic/reset_password_cubit.dart';
import 'package:wavex/features/instructors_screen/logic/instructors_cubit.dart';
import 'package:wavex/features/order_details_screen/logic/order_details_cubit.dart';
import 'package:wavex/features/video_splash_screen/screen/video_splash_screen.dart';

// import 'package:school_livechat_app/core/di/dependency_injection.dart';
// import 'package:school_livechat_app/features/students_absence_info_screen/presentation/screen/students_absence_info_screen.dart';
// import '../../../features/ complaint_screen/presentation/complaint_screen.dart';
// import '../../../features/account_details_screen/presentation/screen/account_details_screen.dart';
// import '../../../features/account_screen/presentation/screen/account_screen.dart';
// import '../../../features/auth/logic/auth_cubit.dart';
// import '../../../features/chat_screen.dart';
// import '../../../features/get_appointments_screen/business_logic/get_appointments_cubit.dart';
// import '../../../features/get_appointments_screen/presentation/screen/get_appointments_screen.dart';
// import '../../../features/get_incidents_screen/presentation/screen/get_incidents_screen.dart';
// import '../../../features/get_request_extracts_screen/business_logic/get_request_extracts_cubit.dart';
// import '../../../features/get_request_extracts_screen/presentation/screen/get_request_extracts_screen.dart';
// import '../../../features/home_screen/presentation/screen/home_screen.dart';
// import '../../../features/issue_child_exit_card_request_screen/presentation/screen/issue_child_exit_card_request_screen.dart';
// import '../../../features/notification_screen/presentation/screen/notification_screen.dart';
// import '../../../features/request_contacts_number_screen/presentation/screen/request_contacts_number_screen.dart';
// import '../../../features/school_screen/presntation/screen/school_screen.dart';
// import '../../../features/student_registration_info_screen/business_logic/student_registration_info_cubit.dart';
// import '../../../features/student_registration_info_screen/data/repository/get_student_registration_info_repository.dart';
// import '../../../features/student_registration_info_screen/presentation/screen/student_registration_info_screen.dart';
// import '../../../features/students_absence_info_screen/business_logic/student_absence_info_cubit.dart';
import '../../../features/add_auto_address_screen/presentation/screen/add_auto_address_screen.dart';
import '../../../features/add_manual_address_screen/logic/address_cubit.dart';
import '../../../features/add_manual_address_screen/presentation/screen/add_manual_address_screen.dart';
import '../../../features/auth/auth_screen/presentation/screen/auth_screen.dart';
import '../../../features/auth/email_verification_screen/presentation/screen/email_verification_screen.dart';
import '../../../features/auth/login_screen/logic/login_cubit.dart';
import '../../../features/auth/login_screen/presentation/screen/login_screen.dart';
import '../../../features/auth/registration_screen/logic/registration_cubit.dart';
import '../../../features/auth/registration_screen/presentation/screen/register_step_one_screen.dart';
import '../../../features/auth/registration_screen/presentation/screen/register_step_two_screen.dart';
import '../../../features/auth/set_new_password_screen/presentation/screen/set_new_password_screen.dart';
import '../../../features/book_program_screen/logic/book_program_cubit.dart';
import '../../../features/book_program_screen/presentation/screen/book_program_screen.dart';
import '../../../features/change_password_screen/logic/change_password_cubit.dart';
import '../../../features/change_password_screen/presentation/screen/change_password_screen.dart';
import '../../../features/checkout_screen/presentation/screen/checkout_screen.dart';
import '../../../features/classes_screen/logic/programs_cubit.dart';
import '../../../features/classes_screen/presentation/screen/classes_screen.dart';
import '../../../features/contact_us_screen/logic/contact_us_cubit.dart';
import '../../../features/contact_us_screen/presentation/screen/contact_us_screen.dart';
import '../../../features/home_screen/logic/home_cubit.dart';
import '../../../features/home_screen/presentation/screen/home_screen.dart';
import '../../../features/instructors_screen/presentation/instructors_screen.dart';
import '../../../features/my_addresses_screen/logic/my_address_cubit.dart';
import '../../../features/my_addresses_screen/presentation/screen/my_addresses_screen.dart';
import '../../../features/order_details_screen/presentation/screen/order_details_screen.dart';
import '../../../features/orders_screen/logic/orders_cubit.dart';
import '../../../features/orders_screen/presentation/screen/orders_screen.dart';
import '../../../features/pay_order_transaction_failed_screen/presentation/screen/pay_order_transaction_failed_screen.dart';
import '../../../features/payment_options_screen/logic/payment_options_cubit.dart';
import '../../../features/payment_options_screen/presentation/screen/payment_options_screen.dart';
import '../../../features/profile_screen/presentation/screen/profile_screen.dart';
import '../../../features/region_selection/logic/region_cubit.dart';
import '../../../features/region_selection/presentation/screen/region_selection_screen.dart';
import '../../../features/branch_selection/logic/branch_cubit.dart';
import '../../../features/branch_selection/presentation/screen/branch_selection_screen.dart';
import '../../../features/liability_acknowledgement/presentation/screen/liability_acknowledgement_screen.dart';
import '../../../features/location_form/presentation/screen/location_form_screen.dart';
import '../../../features/schedule_time_screen/presentation/screen/schedule_time_screen.dart';
import '../../../features/sessions_screen/logic/sessions_cubit.dart';
import '../../../features/sessions_screen/presentation/screen/sessions_screen.dart';
import '../../../features/settings_screen/logic/settings_cubit.dart';
import '../../../features/settings_screen/presentation/screen/settings_screen.dart';
import '../../../features/shop_cart_screen/logic/shop_cart_cubit.dart';
import '../../../features/shop_cart_screen/presentation/screen/shoping_cart_screen.dart';
import '../../../features/shop_screen/logic/shop_cubit.dart';
import '../../../features/shop_screen/presentation/screen/shop_screen.dart';
import '../../../features/splash_screen/presentation/screen/splash_screen.dart';
import '../../../features/transaction_failed_screen/presentation/screen/transaction_failed_screen.dart';
import '../../../features/transaction_success_screen/presentation/screen/transaction_success_screen.dart';
import '../../../features/update_user_profile_screen/logic/update_user_data_cubit.dart';
import '../../../features/update_user_profile_screen/presentation/screen/update_user_profile_screen.dart';
import '../route_strings/route_strings.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteStrings.introVideoScreen:
        return MaterialPageRoute(
          builder: (context) => VideoSplashScreen(),
        );
      case RouteStrings.splashScreen:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case RouteStrings.regionSelectionScreen:
        final returnToBranches = settings.arguments == true;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<RegionCubit>(),
            child: RegionSelectionScreen(returnToBranches: returnToBranches),
          ),
        );
      case RouteStrings.waiverAcknowledgementScreen:
        return MaterialPageRoute(
          builder: (context) => const LiabilityAcknowledgementScreen(),
        );
      case RouteStrings.locationFormScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LocationFormScreen(
            locationId: data['locationId'] as int,
            sessionId: data['sessionId'] as int?,
          ),
        );
      case RouteStrings.branchSelectionScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<BranchCubit>(),
            child: const BranchSelectionScreen(),
          ),
        );
      case RouteStrings.authScreen:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
        );
      case RouteStrings.emailVerificationScreen:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ResetPasswordCubit>(),
            child: EmailVerificationScreen(
              email: data["email"],
            ),
          ),
        );
      case RouteStrings.setNewPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ResetPasswordCubit>(),
            child: const SetNewPasswordScreen(),
          ),
        );
      case RouteStrings.registerStepOneScreen:
        return MaterialPageRoute(
          builder: (context) => const RegisterStepOneScreen(),
        );
      case RouteStrings.registerStepTwoScreen:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<RegistrationCubit>(),
            child: RegisterStepTwoScreen(
              email: data["email"],
              phone: data["phone"],
              dop: data["dop"],
              firstName: data["firstName"],
              lastName: data["lastName"],
              gender: data['gender'],
            ),
          ),
        );
      case RouteStrings.homeScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        );
      case RouteStrings.scheduleTimeScreen:
        return MaterialPageRoute(
          builder: (context) => const ScheduleTimeScreen(),
        );
      case RouteStrings.contactUsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ContactUsCubit>(),
            child: const ContactUsScreen(),
          ),
        );
      case RouteStrings.shoppingCartScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ShopCartCubit>(),
            child: const ShoppingCartScreen(),
          ),
        );
      case RouteStrings.settingsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SettingsCubit>(),
            child: const SettingsScreen(),
          ),
        );
      case RouteStrings.bookProgramScreen:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<BookProgramCubit>(),
            child: BookProgramScreen(
              id: data["id"],
            ),
          ),
        );
      case RouteStrings.profileScreen:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case RouteStrings.updateUserProfileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<UpdateUserDataCubit>(),
            child: const UpdateUserProfileScreen(),
          ),
        );
      case RouteStrings.changePasswordScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ChangePasswordCubit>(),
            child: const ChangePasswordScreen(),
          ),
        );
      case RouteStrings.orderDetailsScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<OrderDetailsCubit>(),
            child: OrderDetailsScreen(
              orderId: data["orderId"],
            ),
          ),
        );
      case RouteStrings.transactionSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => const TransactionSuccessScreen(),
        );
      case RouteStrings.addAutoAddressScreen:
        return MaterialPageRoute(
          builder: (context) => const AddAutoAddressScreen(),
        );
      case RouteStrings.addManualAddressScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<AddressCubit>(),
            child: AddManualAddressScreen(
              addressId: data["addressId"],
            ),
          ),
        );
      case RouteStrings.myAddressesScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<MyAddressCubit>(),
            child: const MyAddressesScreen(),
          ),
        );
      case RouteStrings.transactionFailedScreen:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          settings: settings, // 🟢 هنا بتمرر الاسم
          builder: (context) => BlocProvider.value(
            value: getIt<BookProgramCubit>(),
            child: TransactionFailedScreen(
              sessionId: data["sessionId"],
              label: data["label"],
            ),
          ),
        );
      case RouteStrings.payOrderTransactionFailedScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<PaymentOptionsCubit>(),
            child: PayOrderTransactionFailedScreen(
              addressId: data["addressId"],
              orderId: data["orderId"],
            ),
          ),
        );
      case RouteStrings.instructorsScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<InstructorsCubit>(),
            child: InstructorsScreen(
              instructorId: data["instructorId"],
            ),
          ),
        );
      case RouteStrings.ordersScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<OrdersCubit>(),
            child: const OrdersScreen(),
          ),
        );
      case RouteStrings.sessionsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SessionsCubit>(),
            child: const SessionsScreen(),
          ),
        );
      case RouteStrings.classesScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ProgramsCubit>(),
            child: const ClassesScreen(),
          ),
        );
      case RouteStrings.checkoutScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ShopCartCubit>(),
            child: const CheckoutScreen(),
          ),
        );
      case RouteStrings.paymentOptionsScreen:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<MyAddressCubit>(),
              ),
              BlocProvider.value(
                value: getIt<PaymentOptionsCubit>(),
              ),
            ],
            child: PaymentOptionsScreen(
              orderId: data["orderId"],
            ),
          ),
        );
      case RouteStrings.shopScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ShopCubit>(),
            child: const ShopScreen(),
          ),
        );
      case RouteStrings.loginScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      // case RouteStrings.notificationScreen:
      //   final data = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<NotificationCubit>(),
      //       child: NotificationScreen(
      //         isFromHome: data["isFromHome"],
      //       ),
      //     ),
      //   );
      // case RouteStrings.homeScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const HomeScreen(
      //         // message: RemoteMessage(),
      //         ),
      //   );
      // case RouteStrings.schoolScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const SchoolScreen(
      //         // message: RemoteMessage(),
      //         ),
      //   );
      // case RouteStrings.accountScreen:
      //   final data = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (context) => AccountScreen(
      //       isFromHome: data["isFromHome"],
      //     ),
      //   );
      // case RouteStrings.studentRegistrationInfoScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<StudentRegistrationInfoCubit>(),
      //       child: StudentRegistrationInfoScreen(),
      //     ),
      //   );
      // case RouteStrings.studentAbsenceInfoScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<StudentAbsenceInfoCubit>(),
      //       child: StudentAbsenceInfoScreen(),
      //     ),
      //   );
      // case RouteStrings.requestContactsNumberScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<RequestContactsNumberCubit>(),
      //       child: RequestContactsNumberScreen(),
      //     ),
      //   );
      // case RouteStrings.getAppointmentsScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<GetAppointmentsCubit>(),
      //       child: GetAppointmentsScreen(),
      //     ),
      //   );
      // case RouteStrings.issueChildExitCardRequestScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<IssueChildExitCardRequestCubit>(),
      //       child: IssueChildExitCardRequestScreen(),
      //     ),
      //   );
      // case RouteStrings.getRequestExtractsScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<GetRequestExtractsCubit>(),
      //       child: GetRequestExtractsScreen(),
      //     ),
      //   );
      // case RouteStrings.complaintScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<GetIncidentsCubit>(),
      //       child: const GetIncidentsScreen(),
      //     ),
      //   );
      // case RouteStrings.accountDetailsScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const AccountDetailsScreen(
      //         // message: RemoteMessage(),
      //         ),
      //   );
      // case RouteStrings.webViewScreen:
      //   final data = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => WebViewScreen(
      //       url: data["url"],
      //       notificationId: data['notificationId'],
      //     ),
      //   );
      // case RouteStrings.createAccountScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => CreateAccountScreen(),
      //   );
      // case RouteStrings.loginWithPhoneScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: getIt<LoginWithPhoneCubit>()..getDeviceId(),
      //       child:  LoginWithPhoneScreen(),
      //     ),
      //   );
      // case RouteStrings.verificationScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const VerificationScreen(),
      //   );
      // case RouteStrings.verificationSuccessScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const VerificationSuccessScreen(),
      //   );
      // case RouteStrings.deliveryIdVerificationScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const DeliveryIdVerificationScreen(),
      //   );
      // case RouteStrings.personalInformationScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => PersonalInformationScreen(),
      //   );
      // case RouteStrings.vehicleInformationInputScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => VehicleInformationInputScreen(),
      //   );
      // default:
      //   return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
    return null;
  }
}
