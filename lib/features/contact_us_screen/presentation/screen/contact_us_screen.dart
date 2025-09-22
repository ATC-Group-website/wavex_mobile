import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/contact_us_screen/logic/contact_us_cubit.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/constants/constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final int _selectedBottomNavIndex = 4; // Shopping bag icon is selected

  String email = "";
  String facebook = "";
  String ticTok = "";
  String x = "";
  String instagram = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    ContactUsCubit.get(context).socialLinks();
    ContactUsCubit.get(context).getTopics();
    super.initState();
  }

  Future<void> _launchDynamicUrl(String value) async {
    late Uri uri;

    // Check if it's an email (very simple check)
    if (value.contains("@") && !value.startsWith("http")) {
      uri = Uri(
        scheme: 'mailto',
        path: value,
      );
    } else {
      // Assume it's a normal web link
      uri = Uri.parse(value);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  String? selectedTopic;
  List<String> topics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(
            isWithBack: true,
          ),
          BlocListener<ContactUsCubit, ContactUsState>(
            listener: (context, state) {
              if (state is GetSocialLinksSuccessState) {
                setState(() {
                  facebook = state.socialLinksResponse.data?.facebook ?? "";
                  ticTok = state.socialLinksResponse.data?.tiktok ?? "";
                  x = state.socialLinksResponse.data?.x ?? "";
                  email = state.socialLinksResponse.data?.email ?? "";
                  instagram = state.socialLinksResponse.data?.instagram ?? "";
                });
              }
              if (state is GetTopicsSuccessState) {
                setState(() {
                  topics = state.topicsResponse.data ?? [];
                });
              }
              if (state is ContactUsSuccessState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.contactUsResponse.message ?? ""),
                      backgroundColor: const Color(0xFF45818B),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
              if (state is ContactUsErrorState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error ?? ""),
                      backgroundColor: const Color(0xFF45818B),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
            },
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: _buildContactScreen(),
          ),
          // Bottom wave decoration
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(
            currentIndex: _selectedBottomNavIndex,
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
            Color(0xFF4DB6AC),
            Color(0xFF45818B),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Handle back navigation
                },
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'WAVEX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildContactHeader(),
            const SizedBox(height: 30),
            _buildSocialMediaIcons(),
            const SizedBox(height: 30),
            _buildContactForm(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactHeader() {
    return Column(
      children: [
        Text('Contact Us',
            style: GoogleFonts.inter().copyWith(
              color: const Color(0xFF2E535F),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 16),
        Text(
            'Connection is the first step to collaboration Contact us right now or fill our form',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter().copyWith(
              color: const Color(0xFF2E535F),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
      ],
    );
  }

  Widget _buildSocialMediaIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialIcon(
          icon: "facebook.png",
          color: const Color(0xFF1877F2),
          onTap: () => _showSocialMediaTap(facebook),
        ),
        _buildSocialIcon(
          icon: "x.png", // Using close icon as X placeholder
          color: Colors.black,
          onTap: () => _showSocialMediaTap(x),
        ),
        _buildSocialIcon(
          icon: "instagram.png", // Using camera as Instagram placeholder
          color: const Color(0xFFE4405F),
          onTap: () => _showSocialMediaTap(instagram),
        ),
        _buildSocialIcon(
          icon: "mail.png",
          color: const Color(0xFF45818B),
          onTap: () => _showSocialMediaTap(email),
        ),
        _buildSocialIcon(
          icon: "tiktok.png",
          color: const Color(0xFF45818B),
          onTap: () => _showSocialMediaTap(ticTok),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          width: 50, height: 50, child: Image.asset("assets/images/$icon")),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormField('Name', true, nameController),
            const SizedBox(height: 20),
            _buildFormField('Email', true, emailController),
            const SizedBox(height: 20),
            _buildFormField('Phone', true, phoneController),
            const SizedBox(height: 20),
            _buildDropdownField(),
            const SizedBox(height: 20),
            _buildFormField('Message', true, messageController,
                isTextArea: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Topic",
          style: GoogleFonts.openSans().copyWith(
            color: const Color(0xFF2E535F),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedTopic,
            items: topics
                .map((topic) => DropdownMenuItem(
                      value: topic,
                      child: Text(topic),
                    ))
                .toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                selectedTopic = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
      String label, bool isRequired, TextEditingController controller,
      {bool isTextArea = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.openSans().copyWith(
                  color: const Color(0xFF2E535F),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                )),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: isTextArea ? 120 : 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            maxLines: isTextArea ? 5 : 1,
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "must not be empty";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF45818B),
          padding: const EdgeInsets.symmetric(vertical: 10),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSocialMediaTap(String platform) async {
    await _launchDynamicUrl(platform);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Opening $platform...'),
    //     backgroundColor: const Color(0xFF45818B),
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ContactUsCubit.get(context).contactUs(
        name: nameController.text,
        email: emailController.text,
        topic: selectedTopic,
        phone: phoneController.text,
        body: messageController.text,
        isSubscribedToEmails: false,
      );
    }
  }
}
