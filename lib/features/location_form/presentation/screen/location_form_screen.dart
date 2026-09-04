import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavex/core/components/bottom_navigation_bar.dart';
import 'package:wavex/core/di/dependency_injection.dart';
import 'package:wavex/core/theme/colors.dart';

import '../../data/models/location_form_request.dart';
import '../../logic/location_form_cubit.dart';

class LocationFormScreen extends StatefulWidget {
  const LocationFormScreen(
      {super.key, required this.locationId, this.sessionId});

  final int locationId;
  final int? sessionId;

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _instagram = TextEditingController();
  final _message = TextEditingController();
  String? _age;
  String? _area;
  String? _tried;
  String? _interest;
  String? _priority;
  String? _followed;

  @override
  void dispose() {
    for (final controller in [_name, _phone, _email, _instagram, _message]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;
  String? _requiredChoice(String? value) => value == null ? 'Required' : null;

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<LocationFormCubit>().submit(
          LocationFormRequest(
            locationId: widget.locationId,
            name: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            instagramUsername: _instagram.text.trim(),
            ageRange: _age!,
            preferredClubArea: _area!,
            triedAquaFitness: _tried == 'Yes',
            mostInterestedIn: [_interest!],
            priorityAccess: _priority!,
            followedInstagram: _followed!,
            message: _message.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationFormCubit>(),
      child: BlocListener<LocationFormCubit, LocationFormState>(
        listener: (context, state) {
          if (state is LocationFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pop(true);
          }
          if (state is LocationFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.figmaBackground,
          bottomNavigationBar: const BottomNavigation(currentIndex: 1),
          body: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: _FigmaHeader()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 22),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(13, 12, 13, 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              AppColors.figmaFormBorder.withValues(alpha: 0.52),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _textField('FullName', _name),
                          _textField(
                            'Mobile Number (WhatsApp)',
                            _phone,
                            keyboardType: TextInputType.phone,
                          ),
                          _textField(
                            'Email',
                            _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _textField('Instagram UserName', _instagram),
                          _dropdown(
                            'Age Range',
                            _age,
                            const ['18 - 24', '25 - 34', '35 - 44', '45+'],
                            (value) => setState(() => _age = value),
                          ),
                          _dropdown(
                            'Preferred Club/Area',
                            _area,
                            const ['Egypt', 'UK', 'Other'],
                            (value) => setState(() => _area = value),
                          ),
                          _dropdown(
                            'Have You tried aqua fitness or wellness before',
                            _tried,
                            const ['Yes', 'No'],
                            (value) => setState(() => _tried = value),
                          ),
                          _dropdown(
                            'What are you most interested in',
                            _interest,
                            const ['Fitness', 'Wellness', 'Both'],
                            (value) => setState(() => _interest = value),
                          ),
                          _dropdown(
                            'Would you like priority access to',
                            _priority,
                            const ['New programmes', 'Events', 'All updates'],
                            (value) => setState(() => _priority = value),
                          ),
                          _dropdown(
                            'Have You followed our instagram pages',
                            _followed,
                            const ['Yes', 'No'],
                            (value) => setState(() => _followed = value),
                          ),
                          _instagramLink(
                            'Egypt page',
                            'https://www.instagram.com/',
                          ),
                          _instagramLink(
                            'UK page',
                            'https://www.instagram.com/',
                          ),
                          _textField('Additional Message', _message,
                              maxLines: 4),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(23, 0, 23, 20),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<LocationFormCubit, LocationFormState>(
                      builder: (context, state) {
                        final submitting = state is LocationFormSubmitting;
                        return SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed:
                                submitting ? null : () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.figmaPrimary,
                              disabledBackgroundColor: AppColors.figmaPrimary,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: submitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Submit',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: maxLines,
            validator: _requiredText,
            style: GoogleFonts.poppins(
              color: AppColors.figmaText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> values,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              initialValue: value,
              validator: _requiredChoice,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.figmaText,
              ),
              style: GoogleFonts.poppins(
                color: AppColors.figmaText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: _inputDecoration(),
              items: values
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String label) => RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            color: AppColors.figmaText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
          children: [
            TextSpan(text: label),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFF31010)),
            ),
          ],
        ),
      );

  Widget _instagramLink(String label, String url) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => launchUrl(Uri.parse(url)),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.figmaFormBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/instagram_app_icon.png',
                    width: 27,
                    height: 27,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: AppColors.figmaText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new_rounded,
                    color: Color(0xFFF31010),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  InputDecoration _inputDecoration() => InputDecoration(
        filled: true,
        fillColor: AppColors.figmaInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.figmaPrimary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF31010)),
        ),
      );
}

class _FigmaHeader extends StatelessWidget {
  const _FigmaHeader();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Column(
      children: [
        ClipPath(
          clipper: _HeaderWaveClipper(),
          child: Container(
            height: topInset + 94,
            width: double.infinity,
            color: AppColors.figmaInputFill,
            padding: EdgeInsets.only(top: topInset),
            child: Align(
              alignment: const Alignment(0, -0.45),
              child: Image.asset('assets/images/wavex_logo.png', width: 116),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(19, 0, 19, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.figmaPrimary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Guarantee Your Information\nfor booking :',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.figmaText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'WaveX Egypt',
                      style: GoogleFonts.poppins(
                        color: AppColors.figmaText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 23),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 7);
    path.quadraticBezierTo(
      size.width * 0.44,
      size.height - 30,
      size.width,
      size.height - 12,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
