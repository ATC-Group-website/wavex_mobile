import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wavex/core/app_cubit/app_cubit.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/features/settings_screen/logic/settings_cubit.dart';

import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../main.dart';
import '../../../change_password_screen/presentation/screen/change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String selectedCurrency = 'GBP';
  String? selectedLanguage;
  final TextEditingController _searchController = TextEditingController();

  final List<String> currencies = ['GBP', "USD", "EGP"];
  final List<String> languages = ['English', 'Arabic'];
  bool _notificationsEnabled = false;

  List<Map<String, dynamic>> settingsItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    _loadNotificationPreference();
    _loadCurrencyPreference();
    _searchController.addListener(_filterSearchResults);
    super.initState();
  }

  Future<void> _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString('selectedCurrency') ?? 'GBP';
    setState(() {
      selectedCurrency = savedCurrency;
    });
  }

  Future<void> _setCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', value);
    setState(() {
      selectedCurrency = value;
    });
  }

  _buildCurrencyTile() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return FutureBuilder(
          future: _loadCurrencyPreference(),
          builder: (context, snapshot) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text:
                              '${AppLocalizations.of(context).translate("settings_currency")} : ',
                          style: GoogleFonts.roboto().copyWith(
                            color: const Color(0xFF2E535F),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: selectedCurrency,
                              style: GoogleFonts.roboto().copyWith(
                                color: const Color(0xFFF30F0F),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                        ),
                        onSelected: (String value) {
                          _setCurrency(value);
                          setState(() {
                            selectedCurrency = value;
                          });

                          // MyApp.setLocale(
                          //     context, Locale(selectedLanguage == "English" ? "en" : "ar"));
                        },
                        itemBuilder: (BuildContext context) {
                          return currencies.map((String currency) {
                            return PopupMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    settingsItems = [
      {
        'title':
            AppLocalizations.of(context).translate("settings_notifications"),
        'widget': _buildNotificationTile(),
      },
      // {
      //   'title': AppLocalizations.of(context).translate("settings_language"),
      //   'widget': _buildLanguageTile(),
      // },
      {
        'title': AppLocalizations.of(context).translate("settings_currency"),
        'widget': _buildCurrencyTile(),
      },
      {
        'title':
            AppLocalizations.of(context).translate("settings_changePassword"),
        'widget': _buildChangePasswordTile(),
        'requiresLogin': true,
      },
    ];

    // Reset filter when language changes
    filteredItems = List.from(settingsItems);
    _loadNotificationPreference(); // هيشتغل كل مرة ترجع للشاشة
    _loadCurrencyPreference(); // هيشتغل كل مرة ترجع للشاشة
  }

  void _filterSearchResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = settingsItems.where((item) {
        final title = item['title'].toString().toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  // _buildLanguageTile() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE8F4F8),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         RichText(
  //           text: TextSpan(
  //             text:
  //                 '${AppLocalizations.of(context).translate("settings_language")} : ',
  //             style: GoogleFonts.roboto().copyWith(
  //               color: const Color(0xFF2E535F),
  //               fontSize: 20,
  //               fontWeight: FontWeight.w400,
  //             ),
  //             children: [
  //               TextSpan(
  //                 text: CacheHelper.getdata(key: 'selectedLanguage') == null
  //                     ? 'English'
  //                     : CacheHelper.getdata(key: 'selectedLanguage') == "en"
  //                         ? "English"
  //                         : "Arabic",
  //                 style: GoogleFonts.roboto().copyWith(
  //                   color: const Color(0xFFF30F0F),
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         PopupMenuButton<String>(
  //           icon: const Icon(
  //             Icons.keyboard_arrow_down,
  //             color: AppColors.primaryColor,
  //           ),
  //           onSelected: (String value) async {
  //             setState(() {
  //               selectedLanguage = value;
  //             });
  //
  //             final prefs = await SharedPreferences.getInstance();
  //             await prefs.setString(
  //               'selectedLanguage',
  //               selectedLanguage == "English" ? "en" : "ar",
  //             );
  //             MyApp.setLocale(
  //                 context, Locale(selectedLanguage == "English" ? "en" : "ar"));
  //           },
  //           itemBuilder: (BuildContext context) {
  //             return languages.map((String language) {
  //               return PopupMenuItem<String>(
  //                 value: language,
  //                 child: Text(language),
  //               );
  //             }).toList();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _buildChangePasswordTile() {
    return CacheHelper.getdata(key: "userToken") != null
        ? GestureDetector(
            onTap: () {
              navigatorKey.currentState!
                  .pushNamed(RouteStrings.changePasswordScreen);
            },
            child: Row(
              children: [
                Image.asset("assets/images/water_drop_icon.png"),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!
                        .pushNamed(RouteStrings.changePasswordScreen);
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("settings_changePassword"),
                    style: GoogleFonts.inter().copyWith(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    print(value);
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('news');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('news');
    }

    await prefs.setBool('notifications_enabled', value);
    print(prefs.getBool('notifications_enabled'));

    setState(() {
      _notificationsEnabled = value;
    });

    SettingsCubit.get(context).changeSwitch();
  }

  _buildNotificationTile() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return FutureBuilder(
          future: _loadNotificationPreference(),
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate("settings_notifications"),
                    style: GoogleFonts.aBeeZee().copyWith(
                      color: const Color(0xFF2E535F),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotification,
                    activeColor: AppColors.whiteColor,
                    activeTrackColor: AppColors.primaryColor,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderWidget(isWithBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)
                                .translate("settings_title"),
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF44858F),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate("settings_search"),
                            hintStyle: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primaryColor,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...filteredItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: item['widget'],
                          )),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              const BottomNavigation(currentIndex: 2),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
