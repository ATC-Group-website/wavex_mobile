import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/main.dart';

/// The compact navigation used by the Home and Programs designs.
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.currentIndex});

  final int currentIndex;

  static const _items = <_NavItem>[
    _NavItem('home', 'assets/svg_pictures/home.svg'),
    _NavItem('programs', 'assets/svg_pictures/equipment-gym.svg'),
    _NavItem('profile', 'assets/svg_pictures/user-square.svg'),
    _NavItem('more', 'assets/svg_pictures/dots.svg'),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(RouteStrings.homeScreen, (route) => false);
        break;
      case 1:
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteStrings.classesScreen, (route) => false);
        break;
      case 2:
        navigatorKey.currentState!.pushNamed(RouteStrings.profileScreen);
        break;
      case 3:
        _showMore(context);
        break;
    }
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFB5D7DF),
                    borderRadius: BorderRadius.circular(4))),
            _moreAction(
                sheetContext,
                Icons.shopping_bag_outlined,
                'Shop',
                () => navigatorKey.currentState!
                    .pushNamed(RouteStrings.shopScreen)),
            _moreAction(
                sheetContext,
                Icons.shopping_cart_outlined,
                'Cart',
                () => navigatorKey.currentState!
                    .pushNamed(RouteStrings.shoppingCartScreen)),
            _moreAction(
                sheetContext,
                Icons.contact_support_outlined,
                'Contact us',
                () => navigatorKey.currentState!
                    .pushNamed(RouteStrings.contactUsScreen)),
            _moreAction(sheetContext, Icons.logout, 'Log out', () async {
              await CacheHelper.removeData(key: 'userToken');
              await CacheHelper.removeData(key: 'userImage');
              await CacheHelper.removeData(key: 'userName');
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  RouteStrings.authScreen, (route) => false);
            }),
          ]),
        ),
      ),
    );
  }

  Widget _moreAction(BuildContext context, IconData icon, String label,
          VoidCallback onTap) =>
      ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(label,
            style: const TextStyle(
                color: Color(0xFF315762), fontWeight: FontWeight.w600)),
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 54,
                child: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 49,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF3598C0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33006F9D),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: List.generate(
                            _items.length,
                            (index) => Expanded(
                              child: Semantics(
                                button: true,
                                selected: index == currentIndex,
                                label: _items[index].label,
                                child: InkWell(
                                  onTap: () => _onTap(context, index),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      _items[index].asset,
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: constraints.maxWidth /
                                _items.length *
                                (currentIndex + .5) -
                            16,
                        bottom: 0,
                        child: Container(
                          width: 32,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3598C0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _NavItem {
  const _NavItem(this.label, this.asset);
  final String label;
  final String asset;
}
