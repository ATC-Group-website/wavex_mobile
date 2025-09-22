import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wavex/core/constants/constants.dart';
import 'package:wavex/features/transaction_failed_screen/presentation/screen/transaction_failed_screen.dart';
import 'core/app_cubit/app_cubit.dart';
import 'core/app_localization.dart';
import 'core/di/dependency_injection.dart';
import 'core/helper/bloc_observer/bloc_observer.dart';
import 'core/helper/cache_helper/cache_helper.dart';
import 'core/networks/api_manager.dart';
import 'core/route/router/app_router.dart';
import 'features/home_screen/logic/home_cubit.dart';
import 'features/profile_screen/presentation/screen/profile_screen.dart';
import 'features/transaction_success_screen/presentation/screen/transaction_success_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Constants.publicKey;
  await _initializeApp();
  final String? selectedLanguage =
      CacheHelper.getdata(key: 'selectedLanguage') ?? 'en';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          BlocProvider(
            create: (context) => AppCubit(),
            child: MyApp(
              appRouter: AppRouter(),
              initialLocale: Locale(selectedLanguage!),
            ),
          ), // Wrap your app
    ),
  );

  // runApp(
  //   MyApp(
  //     appRouter: AppRouter(),
  //     initialLocale: Locale(selectedLanguage!),
  //   ),
  // );
  //
  //
}

Future<void> _initializeApp() async {
  await _initializeDependencies();
  await _initializeCache();
}

Future<void> _initializeDependencies() async {
  setupGetIt();
  ApiManager.init();
  Bloc.observer = MyBlocObserver();
}

Future<void> _initializeCache() async {
  try {
    await CacheHelper.init();
  } catch (error) {
    print("Error initializing cache: $error");
  }
}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key, required this.appRouter, required this.initialLocale});

  final AppRouter appRouter;
  final Locale initialLocale;

  static void setLocale(BuildContext context, Locale locale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _locale = widget.initialLocale;
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return BlocProvider.value(
          value: getIt<HomeCubit>(),
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            navigatorKey: navigatorKey,
            locale: _locale,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              return supportedLocales.firstWhere(
                      (element) => element.languageCode == locale?.languageCode,
                  orElse: () => supportedLocales.first);
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: widget.appRouter.generateRoute,
            // home: TransactionFailedScreen(),
          ),
        );
      },
    );
  }
}
