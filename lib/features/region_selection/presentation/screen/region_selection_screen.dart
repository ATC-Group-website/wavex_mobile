import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/region_selection/data/models/country.dart';
import 'package:wavex/features/region_selection/logic/region_cubit.dart';

class RegionSelectionScreen extends StatefulWidget {
  const RegionSelectionScreen({super.key});

  @override
  State<RegionSelectionScreen> createState() => _RegionSelectionScreenState();
}

class _RegionSelectionScreenState extends State<RegionSelectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RegionCubit>().loadRegions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionCubit, RegionState>(
      listener: (context, state) {
        if (state is RegionSaved) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteStrings.authScreen, (route) => false);
        }
      },
      builder: (context, state) {
        final loadedState = _loadedStateFor(state);
        final isSaving = state is RegionSaving;
        final isLoading = state is RegionLoading || state is RegionInitial;
        final error = state is RegionLoadFailure
            ? state.message
            : state is RegionSaveFailure
                ? state.message
                : null;

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.figmaA7D2E3,
                  AppColors.figma9BCCD9,
                  AppColors.figma5EAEC3,
                  AppColors.figma4B899E,
                ],
                stops: [0, 0.16, 0.38, 0.72],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IgnorePointer(
                      child: SvgPicture.asset(
                        'assets/svg_pictures/region_bottom_wave.svg',
                        width: double.infinity,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(38, 48, 38, 96),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/wavex_region_logo.png',
                              width: 258,
                              height: 152,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 58),
                            _RegionDropdown(
                              regions: loadedState?.regions ?? const [],
                              selectedRegion: loadedState?.selectedRegion,
                              isLoading: isLoading,
                              onChanged: isSaving
                                  ? null
                                  : (region) {
                                      if (region != null) {
                                        context
                                            .read<RegionCubit>()
                                            .selectRegion(region);
                                      }
                                    },
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionButton(
                                    label: 'Confirm',
                                    filled: true,
                                    isLoading: isSaving,
                                    isEnabled:
                                        loadedState?.selectedRegion != null &&
                                            !isSaving,
                                    onPressed: context
                                        .read<RegionCubit>()
                                        .confirmSelection,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _ActionButton(
                                    label: 'Cancel',
                                    isEnabled: !isSaving,
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamedAndRemoveUntil(
                                        RouteStrings.authScreen,
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (error != null) ...[
                              const SizedBox(height: 22),
                              Text(
                                'Could not load regions. Please try again.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  color: AppColors.figma316D80,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: isSaving
                                    ? null
                                    : context.read<RegionCubit>().loadRegions,
                                child: Text(
                                  'Try again',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ] else if (loadedState != null &&
                                loadedState.regions.isEmpty) ...[
                              const SizedBox(height: 22),
                              Text(
                                'No regions are available right now.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  color: AppColors.figma316D80,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  RegionLoaded? _loadedStateFor(RegionState state) {
    if (state is RegionLoaded) return state;
    if (state is RegionSaving) return state.loadedState;
    if (state is RegionSaved) return state.loadedState;
    if (state is RegionSaveFailure) return state.loadedState;
    return null;
  }
}

class _RegionDropdown extends StatelessWidget {
  const _RegionDropdown({
    required this.regions,
    required this.selectedRegion,
    required this.isLoading,
    required this.onChanged,
  });

  final List<Country> regions;
  final Country? selectedRegion;
  final bool isLoading;
  final ValueChanged<Country?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.figma316D80.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: selectedRegion,
              isExpanded: true,
              icon: Image.asset(
                'assets/images/region_dropdown_arrow.png',
                width: 18,
                height: 18,
              ),
              dropdownColor: AppColors.figmaFFFFFF,
              hint: Text(
                isLoading ? 'Loading regions...' : 'Select Your Region',
                style: GoogleFonts.outfit(
                  color: AppColors.figmaFFFFFF,
                  fontSize: 21,
                ),
              ),
              style: GoogleFonts.outfit(
                color: AppColors.figmaFFFFFF,
                fontSize: 21,
              ),
              items: regions
                  .map(
                    (region) => DropdownMenuItem<Country>(
                      value: region,
                      child: Text(
                        region.name,
                        style: GoogleFonts.outfit(
                          color: AppColors.figma316D80,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: isLoading ? null : onChanged,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.isEnabled,
    required this.onPressed,
    this.filled = false,
    this.isLoading = false,
  });

  final String label;
  final bool filled;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.figmaFFFFFF : Colors.transparent,
          foregroundColor: AppColors.figma4B899E,
          disabledForegroundColor: AppColors.figma4B899E.withValues(
            alpha: 0.45,
          ),
          side: BorderSide(
            color: filled
                ? AppColors.figmaFFFFFF
                : AppColors.figmaFFFFFF.withValues(alpha: 0.9),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading && filled
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: filled ? FontWeight.w400 : FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
