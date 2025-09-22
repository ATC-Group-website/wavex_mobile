import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wavex/features/add_manual_address_screen/data/repository/address_repository.dart';
import 'package:wavex/features/auth/login_screen/data/repository/login_repository.dart';
import 'package:wavex/features/auth/registration_screen/data/repository/registration_repository.dart';
import 'package:wavex/features/classes_screen/data/repository/programs_repository.dart';
import 'package:wavex/features/home_screen/data/repository/home_repository.dart';
import 'package:wavex/features/instructors_screen/data/repository/instructors_repository.dart';
import 'package:wavex/features/my_addresses_screen/data/repository/my_address_repository.dart';
import 'package:wavex/features/order_details_screen/data/repository/orders_details_repository.dart';
import 'package:wavex/features/orders_screen/data/repository/orders_repository.dart';
import 'package:wavex/features/payment_options_screen/data/repository/payment_options_repository.dart';
import 'package:wavex/features/sessions_screen/logic/sessions_cubit.dart';
import 'package:wavex/features/shop_cart_screen/data/repository/shop_cart_repository.dart';
import 'package:wavex/features/shop_screen/data/repository/shop_repository.dart';

import '../../features/add_manual_address_screen/logic/address_cubit.dart';
import '../../features/auth/login_screen/logic/login_cubit.dart';
import '../../features/auth/password_reset_screen/data/repository/reset_password_repository.dart';
import '../../features/auth/password_reset_screen/logic/reset_password_cubit.dart';
import '../../features/auth/registration_screen/logic/registration_cubit.dart';
import '../../features/book_program_screen/data/repository/book_programs_repository.dart';
import '../../features/book_program_screen/logic/book_program_cubit.dart';
import '../../features/change_password_screen/data/repository/change_password_repository.dart';
import '../../features/change_password_screen/logic/change_password_cubit.dart';
import '../../features/classes_screen/logic/programs_cubit.dart';
import '../../features/contact_us_screen/data/repository/contact_us_repository.dart';
import '../../features/contact_us_screen/logic/contact_us_cubit.dart';
import '../../features/home_screen/logic/home_cubit.dart';
import '../../features/instructors_screen/logic/instructors_cubit.dart';
import '../../features/my_addresses_screen/logic/my_address_cubit.dart';
import '../../features/order_details_screen/logic/order_details_cubit.dart';
import '../../features/orders_screen/logic/orders_cubit.dart';
import '../../features/payment_options_screen/logic/payment_options_cubit.dart';
import '../../features/sessions_screen/data/repository/sessions_repository.dart';
import '../../features/settings_screen/logic/settings_cubit.dart';
import '../../features/shop_cart_screen/logic/shop_cart_cubit.dart';
import '../../features/shop_screen/logic/shop_cubit.dart';
import '../../features/update_user_profile_screen/data/repository/update_user_profile_repository.dart';
import '../../features/update_user_profile_screen/logic/update_user_data_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService

  // login
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt<LoginRepository>()));
  getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepository());

  // Shop
  getIt.registerLazySingleton<ShopCubit>(() => ShopCubit(getIt<ShopRepository>()));
  getIt.registerLazySingleton<ShopRepository>(
      () => ShopRepository());

  // Sessions
  getIt.registerLazySingleton<SessionsCubit>(() => SessionsCubit(getIt<SessionsRepository>()));
  getIt.registerLazySingleton<SessionsRepository>(
      () => SessionsRepository());

  // Orders
  getIt.registerLazySingleton<OrdersCubit>(() => OrdersCubit(getIt<OrdersRepository>()));
  getIt.registerLazySingleton<OrdersRepository>(
      () => OrdersRepository());

  // MyAddress
  getIt.registerLazySingleton<MyAddressCubit>(() => MyAddressCubit(getIt<MyAddressRepository>()));
  getIt.registerLazySingleton<MyAddressRepository>(
      () => MyAddressRepository());

  // Home
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt<HomeRepository>()));
  getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepository());

  // Programs
  getIt.registerLazySingleton<ProgramsCubit>(() => ProgramsCubit(getIt<ProgramsRepository>()));
  getIt.registerLazySingleton<ProgramsRepository>(
      () => ProgramsRepository());

  // BookProgram
  getIt.registerLazySingleton<BookProgramCubit>(() => BookProgramCubit(getIt<BookProgramsRepository>()));
  getIt.registerLazySingleton<BookProgramsRepository>(
      () => BookProgramsRepository());

  // ChangePassword
  getIt.registerLazySingleton<ChangePasswordCubit>(() => ChangePasswordCubit(getIt<ChangePasswordRepository>()));
  getIt.registerLazySingleton<ChangePasswordRepository>(
      () => ChangePasswordRepository());

  // Registration
  getIt.registerLazySingleton<RegistrationCubit>(() => RegistrationCubit(getIt<RegistrationRepository>()));
  getIt.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepository());

  // Address
  getIt.registerLazySingleton<AddressCubit>(() => AddressCubit(getIt<AddressRepository>()));
  getIt.registerLazySingleton<AddressRepository>(
      () => AddressRepository());

  // UpdateUserData
  getIt.registerLazySingleton<UpdateUserDataCubit>(() => UpdateUserDataCubit(getIt<UpdateUserProfileRepository>()));
  getIt.registerLazySingleton<UpdateUserProfileRepository>(
      () => UpdateUserProfileRepository());

  // ResetPassword
  getIt.registerLazySingleton<ResetPasswordCubit>(() => ResetPasswordCubit(getIt<ResetPasswordRepository>()));
  getIt.registerLazySingleton<ResetPasswordRepository>(
      () => ResetPasswordRepository());

  // ContactUs
  getIt.registerLazySingleton<ContactUsCubit>(() => ContactUsCubit(getIt<ContactUsRepository>()));
  getIt.registerLazySingleton<ContactUsRepository>(
      () => ContactUsRepository());

  // ShopCart
  getIt.registerLazySingleton<ShopCartCubit>(() => ShopCartCubit(getIt<ShopCartRepository>()));
  getIt.registerLazySingleton<ShopCartRepository>(
      () => ShopCartRepository());

  // PaymentOptions
  getIt.registerLazySingleton<PaymentOptionsCubit>(() => PaymentOptionsCubit(getIt<PaymentOptionsRepository>()));
  getIt.registerLazySingleton<PaymentOptionsRepository>(
      () => PaymentOptionsRepository());

  // OrderDetails
  getIt.registerLazySingleton<OrderDetailsCubit>(() => OrderDetailsCubit(getIt<OrdersDetailsRepository>()));
  getIt.registerLazySingleton<OrdersDetailsRepository>(
      () => OrdersDetailsRepository());

  // OrderDetails
  getIt.registerLazySingleton<InstructorsCubit>(() => InstructorsCubit(getIt<InstructorsRepository>()));
  getIt.registerLazySingleton<InstructorsRepository>(
      () => InstructorsRepository());

  //Settings
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit());

}
