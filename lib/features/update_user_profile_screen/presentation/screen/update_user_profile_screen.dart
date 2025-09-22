import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/features/update_user_profile_screen/logic/update_user_data_cubit.dart';
import 'package:wavex/main.dart';
import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/components/header_widget.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({super.key});

  @override
  State<UpdateUserProfileScreen> createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyNumber = TextEditingController();
  final int _currentIndex = 3; // Highlight the profile icon in bottom nav

  Map<String, String> splitFullName(String fullName) {
    List<String> parts = fullName.trim().split(" ");

    String firstName = parts.isNotEmpty ? parts.first : "";
    String lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

    return {
      "first_name": firstName,
      "last_name": lastName,
    };
  }

  String _selectedGender = 'female';

  Future<void> _selectDate() async {
    DateTime initialDate;

    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_dobController.text);
      } catch (e) {
        // لو حصل مشكلة في البارس، نخليها 18 سنة فاتت
        initialDate =DateTime(
          DateTime.now().year - 16,
          DateTime.now().month,
          DateTime.now().day,
        );
      }
    } else {
      initialDate = DateTime(
        DateTime.now().year - 16,
        DateTime.now().month,
        DateTime.now().day,
      );
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF26C6DA),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    UpdateUserDataCubit.get(context).getUserProfileData();
    super.initState();
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF668E95) : const Color(0xFFE2F2F5),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Color(0xff48A5B9), width: 5)
                : null),
        child: Center(
          child: Text(
            gender,
            style: GoogleFonts.leagueSpartan().copyWith(
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            // style: TextStyle(
            //   fontSize: 16,
            //   fontWeight: FontWeight.w500,
            //   color: isSelected ? Colors.white : const Color(0xFF666666),
            // ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Custom App Bar
              HeaderWidget(
                isWithBack: true,
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card

                      BlocListener<UpdateUserDataCubit, UpdateUserDataState>(
                        listener: (context, state) {
                          if (state is UpdateUserDataSuccessState) {
                            CacheHelper.saveData(
                                key: "userName",
                                value:
                                    "${_firstNameController.text} ${_lastNameController.text}");
                            CacheHelper.saveData(
                                key: "userPhone",
                                value:
                                    state.userDataResponse.data?.phone ?? "");
                            CacheHelper.saveData(
                                key: "userEmail",
                                value:
                                    state.userDataResponse.data?.email ?? "");
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                      state.userDataResponse.message ?? ""),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            navigatorKey.currentState!
                                .pushNamed(RouteStrings.profileScreen);
                          }
                          if (state is UserProfileDataSuccessState) {
                            setState(() {
                              _fullNameController.text =
                                  '${state.userProfileResponse.data?.firstName ?? ''} ${state.userProfileResponse.data?.lastName ?? ''}';
                              _firstNameController.text =
                                  state.userProfileResponse.data?.firstName ??
                                      '';
                              _lastNameController.text =
                                  state.userProfileResponse.data?.lastName ??
                                      '';
                              _emergencyNumber.text =
                                  state.userProfileResponse.data?.emergencyNumber ??
                                      '';

                              _emailController.text =
                                  state.userProfileResponse.data?.email ?? "";
                              _phoneController.text =
                                  state.userProfileResponse.data?.phone ?? "";
                              _dobController.text =
                                  state.userProfileResponse.data?.dateOfBirth ??
                                      "";
                              _medicalConditions.text = state
                                      .userProfileResponse
                                      .data
                                      ?.medicalConditions ??
                                  "";
                              _selectedGender =
                                  state.userProfileResponse.data?.gender ?? "";
                            });
                          }
                          if (state is UpdateUserDataErrorState) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.error ?? ""),
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                        },
                        child: SizedBox.shrink(),
                      ),
                      _buildProfileCard(),

                      const SizedBox(height: 10),

                      // Form Fields
                      _buildFormFields(),

                      const SizedBox(height: 20),

                      // Update Profile Button
                      _buildUpdateButton(),

                      const SizedBox(height: 20),

                      // Change Password Link
                      _buildChangePasswordLink(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              BottomNavigation(
                currentIndex: _currentIndex,
              ),
            ],
          ),

          // Wave background at bottom
          // const Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: WaveBackground(),
          // ),
        ],
      ),
    );
  }

  Widget _roundedField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF7CA6B0)),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       'My Profile',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     // Container(
          //     //   padding: const EdgeInsets.all(8),
          //     //   decoration: BoxDecoration(
          //     //     color: Colors.white.withOpacity(0.2),
          //     //     shape: BoxShape.circle,
          //     //   ),
          //     //   child: const Icon(
          //     //     Icons.notifications_outlined,
          //     //     color: Colors.white,
          //     //     size: 24,
          //     //   ),
          //     // ),
          //   ],
          // ),
          // const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    CacheHelper.getdata(key: "userImage") ??
                        "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CacheHelper.getdata(key: "userName") ?? "Guest",
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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildFieldLabel('Full Name'),
        // const SizedBox(height: 8),
        // CustomTextField(controller: _fullNameController),

        // Full Name field
        _buildFieldLabel(
          AppLocalizations.of(context).translate("first_name"),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _firstNameController,
          hintText: AppLocalizations.of(context).translate("enter_first_name"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)
                  .translate("first_name_required");
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Full Name field
        _buildFieldLabel(
          AppLocalizations.of(context).translate("last_name"),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _lastNameController,
          hintText: AppLocalizations.of(context).translate("enter_last_name"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)
                  .translate("last_name_required");
            }
            return null;
          },
        ),

        const SizedBox(height: 20),
        _buildFieldLabel(
          'Phone Number',
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          hintText: "phone number",
        ),
        const SizedBox(height: 20),
        _buildFieldLabel('Email'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: false,
        ),
        const SizedBox(height: 20),
        _buildFieldLabel('Emergency Number'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emergencyNumber,
          keyboardType: TextInputType.phone,
          hintText: "emergency number",
        ),
        const SizedBox(height: 20),

        // Date of Birth field
        _buildFieldLabel(
          AppLocalizations.of(context).translate("dob"),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: _buildTextField(
              controller: _dobController,
              hintText: AppLocalizations.of(context).translate("dob_hint"),
              validator: (value) {
                if (value == null || value.isEmpty || value == 'YYY-MM-DD') {
                  return AppLocalizations.of(context).translate("dob_required");
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Gender field
        _buildFieldLabel(
          AppLocalizations.of(context).translate("gender"),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton("male"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderButton(
                "female",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderButton(
                "other",
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        _buildFieldLabel(
          AppLocalizations.of(context).translate("medical_conditions"),
        ),
        const SizedBox(height: 8),
        _roundedField(
          controller: _medicalConditions,
          hint:
              AppLocalizations.of(context).translate("medical_conditions_hint"),
        ),
      ],
    );
  }

  final _medicalConditions = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.leagueSpartan().copyWith(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        // style: const TextStyle(
        //   fontSize: 16,
        //   color: Color(0xFF666666),
        // ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: hintText,
          hintStyle: GoogleFonts.leagueSpartan().copyWith(
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // Future<void> _selectDate() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().subtract(const Duration(days: 6570)),
  //     // 18 years ago
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: Color(0xFF26C6DA),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text =
  //           '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
  //     });
  //   }
  // }

  Widget _buildFieldLabel(String label) {
    return Text(label,
        style: GoogleFonts.leagueSpartan().copyWith(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ));
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Handle update profile
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Profile updated successfully!')),
          // );
          var result = splitFullName(_fullNameController.text);

          UpdateUserDataCubit.get(context).updateUserData(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            emergencyNumber: _emergencyNumber.text,
            email: CacheHelper.getdata(key: "userEmail") ==
                    _emailController.text.trim()
                ? null
                : _emailController.text.trim(),
            phone: CacheHelper.getdata(key: "userPhone") ==
                    _phoneController.text.trim()
                ? null
                : _phoneController.text,
            medical: _medicalConditions.text.trim(),
            dateOfBirth: _dobController.text,
            gender: _selectedGender,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text('Update Profile',
            style: GoogleFonts.inter().copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  Widget _buildChangePasswordLink() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                'Change Password',
                style: GoogleFonts.inter().copyWith(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fullNameController.dispose();
    _emergencyNumber.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
