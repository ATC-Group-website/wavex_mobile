import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/di/dependency_injection.dart';

import '../../features/home_screen/data/models/notifications_response.dart';
import '../../features/home_screen/logic/home_cubit.dart';
import '../../main.dart';
import '../app_localization.dart';
import '../helper/cache_helper/cache_helper.dart';
import '../route/route_strings/route_strings.dart';
import '../theme/colors.dart';
import 'login_required_dialog.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool _showLogoutDialog = false;

  void _hideLogoutDialog() {
    setState(() {
      _showLogoutDialog = false;
    });
    Navigator.pop(context);
  }

  void _performLogout() async {
    // Implement logout logic here
    Navigator.pop(context);
    if( CacheHelper.getdata(key: "userToken")!=null){
      CacheHelper.removeData(key: "userToken");
      CacheHelper.removeData(key: "userImage");
      CacheHelper.removeData(key: "userEmail");
      CacheHelper.removeData(key: "userPhone");
      CacheHelper.removeData(key: "userName");
      CacheHelper.removeData(key: "userId");
      CacheHelper.removeData(key: "orderId").then(
            (value) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).translate("logout_success")),
                backgroundColor: Colors.teal,
              ),
            );
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteStrings.loginScreen,
                (route) => false,
          );
        },
      );
    }else{
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content:
            Text(AppLocalizations.of(context).translate("logout_success")),
            backgroundColor: Colors.teal,
          ),
        );
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteStrings.loginScreen,
            (route) => false,
      );
    }
    // await CacheHelper.clearData().then(
    //   (value) {
    //     ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //       const SnackBar(
    //         content: Text('Logged out successfully'),
    //         backgroundColor: Colors.teal,
    //       ),
    //     );
    //     navigatorKey.currentState!.pushNamedAndRemoveUntil(
    //       RouteStrings.loginScreen,
    //       (route) => false,
    //     );
    //   },
    // );
  }

  Widget _buildLogoutModal() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _hideLogoutDialog,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: _performLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Yes, Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoginRequiredDialog();
      },
    );
  }

  void _showLogoutConfirmation() {
    setState(() {
      _showLogoutDialog = true;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLogoutModal(),
    );
  }

  // void _showNotifications() {
  //   setState(() {
  //     _showLogoutDialog = true;
  //   });
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => _buildNotificationsModal(),
  //   );
  // }

  Widget _buildNotificationsModal(
    BuildContext context,
    List<NotificationData> notifications,
    bool hasMore,
    void Function() loadMore,
  ) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMore) {
          loadMore();
        }
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/svg_pictures/Bell.svg"),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate("home_notifications"),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount:
                  hasMore ? notifications.length + 1 : notifications.length,
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final n = notifications[index];
                return ListTile(
                  onTap: () {
                    HomeCubit.get(context)
                        .markNotificationAsRead(notificationId: n.id ?? 0);
                  },
                  leading: Icon(Icons.notifications,
                      color: n.readAt != null ? Colors.grey : Colors.blue),
                  title: Text(
                    n.title ?? "",
                    style: GoogleFonts.inter().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: n.readAt != null ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    n.description ?? "",
                    style: GoogleFonts.inter().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: n.readAt != null
                          ? Colors.grey
                          : const Color(0xFF45818B),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeCubit>(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            if (widget.currentIndex == index) {
            } else {
              if (index == 0) {
                navigatorKey.currentState!.pushNamed(RouteStrings.homeScreen);
              }
              if (index == 1) {
                navigatorKey.currentState!
                    .pushNamed(RouteStrings.classesScreen);
              }
              if (index == 2) {
                navigatorKey.currentState!.pushNamed(RouteStrings.shopScreen);
              }
              if (index == 3) {
                navigatorKey.currentState!
                    .pushNamed(RouteStrings.profileScreen);
              }
              if (index == 4) {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading:
                                SvgPicture.asset("assets/svg_pictures/cart.svg"),
                            title: Text(
                              "Cart",
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF44858F),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 0.80,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              navigatorKey.currentState!
                                  .pushNamed(RouteStrings.shoppingCartScreen);
                              // Handle contact action
                            },
                            // onTap:  CacheHelper.getdata(key: "userToken") == null
                            //     ? () => showLoginRequiredDialog(context)
                            //     : () {
                            //   Navigator.pop(context);
                            //   navigatorKey.currentState!
                            //       .pushNamed(RouteStrings.shoppingCartScreen);
                            //   // Handle contact action
                            // },
                          ),
                          ListTile(
                            leading: SvgPicture.asset(
                                "assets/svg_pictures/contact_us.svg"),
                            title: Text(
                              "Contact Us",
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF44858F),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 0.80,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              navigatorKey.currentState!
                                  .pushNamed(RouteStrings.contactUsScreen);
                              // Handle contact action
                            },
                          ),
                          ListTile(
                            leading: SvgPicture.asset(
                                "assets/svg_pictures/notification.svg"),
                            title: Text(
                              "Notifications",
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF44858F),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 0.80,
                              ),
                            ),
                            onTap: CacheHelper.getdata(key: "userToken") == null
                                ? () => showLoginRequiredDialog(context)
                                : () {
                                    Navigator.pop(context);
                                    HomeCubit.get(context)
                                        .getNotification(pageNumber: 1);

                                    HomeCubit cubit = HomeCubit.get(context);
                                    cubit.getNotification(pageNumber: 1);

                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value: cubit,
                                          // ✅ نفس instance بتاعة HomeCubit
                                          child:
                                              BlocBuilder<HomeCubit, HomeState>(
                                            builder: (context, state) {
                                              if (state
                                                      is GetNotificationLoadingState &&
                                                  cubit.allNotifications
                                                      .isEmpty) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              if (state
                                                  is MarkNotificationAsReadSuccessState) {
                                                HomeCubit.get(context)
                                                    .getNotification(
                                                  pageNumber: cubit.currentPage,
                                                );
                                              }

                                              if (state
                                                  is GetNotificationErrorState) {
                                                Navigator.pop(context);
                                                return Center(
                                                  child: Text(
                                                      "Error: ${state.error}"),
                                                );
                                              }

                                              return _buildNotificationsModal(
                                                context,
                                                cubit.allNotifications,
                                                cubit.currentPage <
                                                    cubit.lastPage,
                                                () => cubit.getNotification(
                                                    pageNumber:
                                                        cubit.currentPage + 1),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                    // Handle contact action
                                  },
                          ),
                          ListTile(
                            leading: SvgPicture.asset(
                              "assets/svg_pictures/logout.svg",
                            ),
                            title: Text(
                              "Logout",
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF44858F),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 0.80,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _showLogoutConfirmation();
                              // Handle logout action
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
            // setState(() {
            //   _currentIndex = index;
            // });
            // HapticFeedback.selectionClick();
            // Handle navigation based on index
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0288D1),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg_pictures/home.svg"),
              activeIcon: Column(
                children: [
                  SvgPicture.asset("assets/svg_pictures/home.svg"),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 20, height: 4, color: const Color(0xFF48A5B7)),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg_pictures/equipment-gym.svg"),
              activeIcon: Column(
                children: [
                  SvgPicture.asset("assets/svg_pictures/equipment-gym.svg"),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 20, height: 4, color: const Color(0xFF48A5B7)),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg_pictures/bag.svg"),
              activeIcon: Column(
                children: [
                  SvgPicture.asset("assets/svg_pictures/bag.svg"),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 20, height: 4, color: const Color(0xFF48A5B7)),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg_pictures/user-square.svg"),
              activeIcon: Column(
                children: [
                  SvgPicture.asset("assets/svg_pictures/user-square.svg"),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 20, height: 4, color: const Color(0xFF48A5B7)),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: double.infinity,
                // height: double.infinity,
                child: SvgPicture.asset(
                  "assets/svg_pictures/dots.svg",
                  height: 7,
                ),
              ),
              activeIcon: SvgPicture.asset(
                "assets/svg_pictures/dots.svg",
                height: 5,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
