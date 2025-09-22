import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavex/core/app_localization.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/main.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/login_required_dialog.dart';
import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';
import '../../../../core/networks/request_body.dart';
import '../../../../core/theme/colors.dart';
import 'package:image/image.dart' as img;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Highlight the profile icon in bottom nav
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
    if (CacheHelper.getdata(key: "userToken") != null) {
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
    } else {
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
    // CacheHelper.removeData(key: "userToken");
    // await CacheHelper.clearData().then(
    //   (value) {
    //
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
          Text(
            AppLocalizations.of(context).translate("logout_confirmation"),
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
                  child: Text(
                    AppLocalizations.of(context).translate("cancel"),
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
                  child: Text(
                    AppLocalizations.of(context).translate("yes_logout"),
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
@override
  void initState() {
    // TODO: implement initState
  if (_selectedImageBytes != null) {
    backgroundImage = MemoryImage(_selectedImageBytes!);
  } else if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
    backgroundImage = NetworkImage(_uploadedImageUrl!);
  } else {
    backgroundImage = NetworkImage(CacheHelper.getdata(key: "userImage") ??
        "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=");
  }
    super.initState();
  }
  ImageProvider? backgroundImage;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(),
          // _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildMenuItems(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          BottomNavigation(
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4FC3F7),
            Color(0xFF29B6F6),
            Color(0xFF0288D1),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Example: go back
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Text(
              'WAVEX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Row(
              children: [
                // Signal bars
                ...List.generate(
                    4,
                    (index) => Container(
                          margin: const EdgeInsets.only(right: 2),
                          width: 3,
                          height: 8 + (index * 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )),
                const SizedBox(width: 8),
                const Icon(Icons.wifi, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> convertImageToBase64(File pickedFile) async {
    // Pick an image using image_picker
    List<int> imageBytes = await pickedFile.readAsBytes();

    // Convert to Base64 string
    String base64String = base64Encode(imageBytes);
    print("Base64 String: $base64String");

    return base64String;
  }

  Future<void> _launchUrl({
    required String printUrl,
  }) async {
    Uri url = Uri.parse(
      printUrl,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<ApiResponse?> updateProfileImage({required String image}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'users',
        body: RequestBody({
          "image": image.isNotEmpty ? "data:image/jpg;base64,$image" : "",
          "first_name": CacheHelper.getdata(key: "firstName"),
          "last_name": CacheHelper.getdata(key: "lastName"),
          "gender": CacheHelper.getdata(key: "gender"),
        }),
        method: Method.PUT,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  String? _uploadedImageUrl;
  Uint8List? _uploadedImage;
  Uint8List? _selectedImageBytes;

  Future<Uint8List> _compressImageBytes(Uint8List bytes) async {
    final image = img.decodeImage(bytes)!;
    final resized = img.copyResize(image, width: 200);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 70));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final base64Image = await convertImageToBase64(file);
      final bytes = await file.readAsBytes();
      //
      final compressedBytes = await _compressImageBytes(bytes);

      if (compressedBytes.length > 20000) {
        throw Exception(
            'Image must be smaller than 20KB (current: ${compressedBytes.length ~/ 1024}KB)');
      }

      await updateProfileImage(image: base64Image).then(
        (value) {
          if (value?.statusCode == 200) {
            print(jsonDecode(value!.data)["data"]["image"]);
            CacheHelper.saveData(
                key: "userImage",
                value: jsonDecode(value.data)["data"]["image"]);
            if (_selectedImageBytes != null) {
              backgroundImage = MemoryImage(_selectedImageBytes!);
            } else if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
              backgroundImage = NetworkImage(_uploadedImageUrl!);
            } else {
              backgroundImage = NetworkImage(CacheHelper.getdata(key: "userImage") ??
                  "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=");
            }
            setState(() {

            });
          }
        },
      ).catchError((error) {});
      setState(() {
        _selectedImageBytes = bytes;
        _uploadedImage = null;
      });
    }
  }

  Future<void> deleteProfileImage() async {
    await updateProfileImage(image: "").then(
      (value) {
        if (value?.statusCode == 200) {
          print(jsonDecode(value!.data)["data"]["image"]);
          CacheHelper.saveData(
              key: "userImage", value: jsonDecode(value.data)["data"]["image"]);
          setState(() {
            backgroundImage = NetworkImage(CacheHelper.getdata(key: "userImage") ?? "");
          });
        }
      },
    ).catchError((error) {});
    setState(() {
      // _selectedImageBytes = bytes;
      _uploadedImage = null;
    });
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4ABAD2),
            Color(0xFF479FB1),
            AppColors.primaryColor
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate("my_profile"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Icon(
              //     Icons.notifications_outlined,
              //     color: Colors.white,
              //     size: 24,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: backgroundImage,
                    // child: ClipOval(
                    //   child: Image.network(
                    //     CacheHelper.getdata(key: "userImage") ?? "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=",
                    //     width: 90,
                    //     height: 90,
                    //     fit: BoxFit.cover,
                    //     errorBuilder: (context, error, stackTrace) {
                    //       return Container(
                    //         width: 90,
                    //         height: 90,
                    //         color: Colors.grey[300],
                    //         child: const Icon(Icons.person, color: Colors.grey),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: CacheHelper.getdata(key: "userToken") == null
                          ? () => showLoginRequiredDialog(context)
                          : _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: SvgPicture.asset(
                          "assets/svg_pictures/Icon.svg",
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: InkWell(
                      onTap: CacheHelper.getdata(key: "userToken") == null
                          ? () => showLoginRequiredDialog(context)
                          : deleteProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CacheHelper.getdata(key: "userName") ??
                          AppLocalizations.of(context).translate("home_guest"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CacheHelper.getdata(key: "userPhone") != ""
                        ? Text(
                            CacheHelper.getdata(key: "userPhone") ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          )
                        : const SizedBox.shrink(),
                    Text(
                      CacheHelper.getdata(key: "userEmail") ?? "",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildMenuItems() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.person_outline,
        'label': AppLocalizations.of(context).translate("profile"),
        'onTap': () {
          if (CacheHelper.getdata(key: "userToken") != null) {
            navigatorKey.currentState!
                .pushNamed(RouteStrings.updateUserProfileScreen);
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate("guest_mode")),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
      },
      {
        'icon': Icons.timer_outlined,
        'label': AppLocalizations.of(context).translate("my_sessions"),
        'onTap': () {
          if (CacheHelper.getdata(key: "userToken") != null) {
            navigatorKey.currentState!.pushNamed(
              RouteStrings.sessionsScreen,
            );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate("guest_mode")),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
      },
      {
        'icon': Icons.archive_outlined,
        'label': AppLocalizations.of(context).translate("my_orders"),
        'onTap': () {
          if (CacheHelper.getdata(key: "userToken") != null) {
            navigatorKey.currentState!.pushNamed(
              RouteStrings.ordersScreen,
            );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate("guest_mode")),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
      },
      {
        'icon': Icons.settings_outlined,
        'label': AppLocalizations.of(context).translate("settings"),
        'onTap': () {
          navigatorKey.currentState!.pushNamed(
            RouteStrings.settingsScreen,
          );
        },
      },
      {
        'icon': Icons.lock_outline,
        'label': AppLocalizations.of(context).translate("privacy_policy"),
        'onTap': () {
          _launchUrl(printUrl: "https://wavexsports.com/privacy-policy");
        },
      },
      {
        'icon': Icons.location_on_outlined,
        'label': AppLocalizations.of(context).translate("addresses"),
        'onTap': () {
          if (CacheHelper.getdata(key: "userToken") != null) {
            navigatorKey.currentState!.pushNamed(
              RouteStrings.myAddressesScreen,
            );
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate("guest_mode")),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
      },
      {
        'icon': Icons.logout,
        'label': AppLocalizations.of(context).translate("logout"),
        'onTap': () => _showLogoutConfirmation(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: menuItems.map((item) {
          return _buildMenuItem(
            item['icon'] as IconData,
            item['label'] as String,
            item['onTap'] as VoidCallback,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4ABBD5),
                    Color(0xFF47A0B2),
                    AppColors.primaryColor
                  ],
                ),
                shape: OvalBorder(),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.leagueSpartan().copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            label == "Logout" || label == "تسجيل الخروج"
                ? const SizedBox.shrink()
                : const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
          ],
        ),
      ),
    );
  }
}
