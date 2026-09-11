import 'package:wavex/core/utils/app_logger.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crop_your_image/crop_your_image.dart';
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

enum ProfileImageUploadStatus { idle, uploading, success, failure }

class _ProfilePhotoCropDialog extends StatefulWidget {
  const _ProfilePhotoCropDialog({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<_ProfilePhotoCropDialog> createState() =>
      _ProfilePhotoCropDialogState();
}

class _ProfilePhotoCropDialogState extends State<_ProfilePhotoCropDialog> {
  final CropController _cropController = CropController();
  bool _isCropping = false;
  String? _cropError;

  void _cropImage() {
    setState(() {
      _isCropping = true;
      _cropError = null;
    });
    _cropController.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Position your profile photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Drag the image to reposition it, or pinch to zoom.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Crop(
                    image: widget.imageBytes,
                    controller: _cropController,
                    aspectRatio: 1,
                    withCircleUi: true,
                    interactive: true,
                    fixCropRect: true,
                    baseColor: AppColors.primaryColor,
                    maskColor: Colors.black.withAlpha(140),
                    progressIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    onCropped: (result) {
                      if (!mounted) return;
                      if (result is CropSuccess) {
                        Navigator.of(context).pop(result.croppedImage);
                        return;
                      }

                      final failure = result as CropFailure;
                      setState(() {
                        _isCropping = false;
                        _cropError =
                            'We could not crop this photo. Please try again.';
                      });
                      appLog('Unable to crop profile image: ${failure.cause}');
                    },
                  ),
                ),
              ),
              if (_cropError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _cropError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isCropping ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isCropping ? null : _cropImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isCropping
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Use photo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 2; // Highlight the profile icon in bottom nav
  ProfileImageUploadStatus _imageUploadStatus = ProfileImageUploadStatus.idle;
  String? _imageUploadError;
  void _hideLogoutDialog() {
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
          if (!mounted) return;
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
            style: const TextStyle(
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
                    style: const TextStyle(
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
                    style: const TextStyle(
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
          const HeaderWidget(),
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
    // The current API validates a full profile update. Retrieve the server's
    // source of truth first so an avatar change preserves the required fields.
    final currentProfileResponse = await ApiManager.sendRequest(
      link: 'user/profile',
      method: Method.GET,
    );
    final currentProfile = _profileDataFromResponse(currentProfileResponse);

    return ApiManager.sendRequest(
      link: 'users',
      body: RequestBody({
        'first_name': _requiredProfileValue(currentProfile, 'first_name'),
        'last_name': _requiredProfileValue(currentProfile, 'last_name'),
        'gender': _requiredProfileValue(currentProfile, 'gender'),
        'country_id': _requiredProfileValue(currentProfile, 'country_id'),
        "image": image.isNotEmpty ? "data:image/jpeg;base64,$image" : "",
      }),
      method: Method.PUT,
    );
  }

  Map<String, dynamic> _profileDataFromResponse(ApiResponse? response) {
    if (response?.statusCode != 200 && response?.statusCode != 201) {
      throw const FormatException(
          'We could not load your current profile. Please try again.');
    }

    final payload = _decodeResponseData(response?.data);
    if (payload is! Map || payload['data'] is! Map) {
      throw const FormatException(
          'We could not load your current profile. Please try again.');
    }
    return Map<String, dynamic>.from(payload['data'] as Map);
  }

  dynamic _requiredProfileValue(Map<String, dynamic> profile, String key) {
    final value = profile[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      throw const FormatException(
          'Your profile is missing required information. Please update your profile and try again.');
    }
    return value;
  }

  dynamic _decodeResponseData(dynamic data) {
    return data is String ? jsonDecode(data) : data;
  }

  String? _uploadedImageUrl;
  Uint8List? _selectedImageBytes;

  Future<Uint8List> _compressImageBytes(Uint8List bytes) async {
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw const FormatException(
          'Please choose a JPG, PNG, GIF, or WebP image.');
    }

    final orientedImage = img.bakeOrientation(image);
    final longestSide = orientedImage.width > orientedImage.height
        ? orientedImage.width
        : orientedImage.height;
    final resized = longestSide > 800
        ? img.copyResize(
            orientedImage,
            width: orientedImage.width >= orientedImage.height ? 800 : null,
            height: orientedImage.height > orientedImage.width ? 800 : null,
          )
        : orientedImage;

    // The API optimizes profile images as JPEGs. Encoding here keeps the upload
    // small and makes the data URI match the bytes we send.
    return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
  }

  Future<void> _pickImage() async {
    if (_imageUploadStatus == ProfileImageUploadStatus.uploading) return;

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );
      if (pickedFile == null) return;

      final originalBytes = await pickedFile.readAsBytes();
      if (!mounted) return;

      final croppedImage = await _showImageEditor(originalBytes);
      if (croppedImage == null || !mounted) return;

      await _uploadProfileImage(await _compressImageBytes(croppedImage));
    } catch (error, stackTrace) {
      appLog('Unable to prepare profile image: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _imageUploadStatus = ProfileImageUploadStatus.failure;
        _imageUploadError = _friendlyImageError(error);
      });
    }
  }

  Future<Uint8List?> _showImageEditor(Uint8List imageBytes) {
    return showDialog<Uint8List>(
      context: context,
      builder: (_) => _ProfilePhotoCropDialog(imageBytes: imageBytes),
    );
  }

  Future<void> _uploadProfileImage(Uint8List imageBytes) async {
    setState(() {
      _imageUploadStatus = ProfileImageUploadStatus.uploading;
      _imageUploadError = null;
    });

    try {
      final response =
          await updateProfileImage(image: base64Encode(imageBytes));
      final imageUrl = _imageUrlFromResponse(response);
      if (imageUrl == null || imageUrl.isEmpty) {
        throw const FormatException(
            'The server did not return a profile image.');
      }

      await CacheHelper.saveData(key: 'userImage', value: imageUrl);
      if (!mounted) return;
      setState(() {
        _selectedImageBytes = imageBytes;
        _uploadedImageUrl = imageUrl;
        backgroundImage = MemoryImage(imageBytes);
        _imageUploadStatus = ProfileImageUploadStatus.success;
      });
    } catch (error, stackTrace) {
      appLog('Unable to upload profile image: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _imageUploadStatus = ProfileImageUploadStatus.failure;
        _imageUploadError = _friendlyImageError(error);
      });
    }
  }

  String? _imageUrlFromResponse(ApiResponse? response) {
    if (response?.statusCode != 200 && response?.statusCode != 201) {
      return null;
    }

    final dynamic payload = _decodeResponseData(response?.data);
    if (payload is! Map) return null;

    final data = payload['data'];
    return data is Map ? data['image'] as String? : null;
  }

  String _friendlyImageError(Object error) {
    if (error is FormatException) return error.message;
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty
        ? 'We could not upload your photo. Please try again.'
        : message;
  }

  Future<void> deleteProfileImage() async {
    if (_imageUploadStatus == ProfileImageUploadStatus.uploading) return;

    setState(() {
      _imageUploadStatus = ProfileImageUploadStatus.uploading;
      _imageUploadError = null;
    });

    try {
      final response = await updateProfileImage(image: '');
      final imageUrl = _imageUrlFromResponse(response);
      if (imageUrl == null || imageUrl.isEmpty) {
        throw const FormatException(
            'The server did not return a profile image.');
      }

      await CacheHelper.saveData(key: 'userImage', value: imageUrl);
      if (!mounted) return;
      setState(() {
        _selectedImageBytes = null;
        _uploadedImageUrl = imageUrl;
        backgroundImage = NetworkImage(imageUrl);
        _imageUploadStatus = ProfileImageUploadStatus.success;
      });
    } catch (error, stackTrace) {
      appLog('Unable to remove profile image: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _imageUploadStatus = ProfileImageUploadStatus.failure;
        _imageUploadError = _friendlyImageError(error);
      });
    }
  }

  Widget _buildImageUploadStatus() {
    switch (_imageUploadStatus) {
      case ProfileImageUploadStatus.idle:
        return const SizedBox.shrink();
      case ProfileImageUploadStatus.uploading:
        return const Padding(
          padding: EdgeInsets.only(top: 14),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Uploading profile photo…',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        );
      case ProfileImageUploadStatus.success:
        return const Padding(
          padding: EdgeInsets.only(top: 14),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Profile photo updated',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        );
      case ProfileImageUploadStatus.failure:
        return Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _imageUploadError ??
                      'We could not upload your photo. Please try again.',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        );
    }
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
                style: const TextStyle(
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
                  if (_imageUploadStatus == ProfileImageUploadStatus.uploading)
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0x66000000),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: CacheHelper.getdata(key: "userToken") == null
                          ? () => showLoginRequiredDialog(context)
                          : _imageUploadStatus ==
                                  ProfileImageUploadStatus.uploading
                              ? null
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
                          : _imageUploadStatus ==
                                  ProfileImageUploadStatus.uploading
                              ? null
                              : deleteProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Icon(
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
          _buildImageUploadStatus(),
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
