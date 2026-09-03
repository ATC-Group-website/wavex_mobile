import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/app_localization.dart';
import 'package:wavex/core/constants/cache_keys.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/branch_selection/data/models/branch.dart';
import 'package:wavex/features/branch_selection/logic/branch_cubit.dart';

class BranchSelectionScreen extends StatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  State<BranchSelectionScreen> createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  int? _regionId;

  @override
  void initState() {
    super.initState();
    final savedRegionId = CacheHelper.getdata(key: CacheKeys.selectedCountryId);
    _regionId = savedRegionId is int ? savedRegionId : null;
    if (_regionId != null) {
      context.read<BranchCubit>().loadBranches(_regionId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final regionName =
        CacheHelper.getdata(key: CacheKeys.selectedCountryName) as String?;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(localizations.translate('branch_title')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              RouteStrings.regionSelectionScreen,
              (route) => false,
              arguments: true,
            ),
            child: Text(localizations.translate('change_region')),
          ),
        ],
      ),
      body: BlocBuilder<BranchCubit, BranchState>(
        builder: (context, state) {
          if (_regionId == null) {
            return _MessageState(
              message: localizations.translate('branch_missing_region'),
              actionLabel: localizations.translate('change_region'),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                RouteStrings.regionSelectionScreen,
                (route) => false,
                arguments: true,
              ),
            );
          }
          if (state is BranchLoading || state is BranchInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BranchLoadFailure) {
            return _MessageState(
              message: localizations.translate('branch_load_error'),
              actionLabel: localizations.translate('try_again'),
              onPressed: () =>
                  context.read<BranchCubit>().loadBranches(_regionId!),
            );
          }

          final loaded = state as BranchLoaded;
          if (loaded.branches.isEmpty) {
            return _MessageState(
              message: localizations.translate('branch_empty'),
              actionLabel: localizations.translate('try_again'),
              onPressed: () =>
                  context.read<BranchCubit>().loadBranches(_regionId!),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  '${localizations.translate('branch_region_label')}: ${regionName ?? ''}',
                  style: GoogleFonts.inter(
                    color: AppColors.figma316D80,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: loaded.branches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final branch = loaded.branches[index];
                    return _BranchCard(
                      branch: branch,
                      isSelected: loaded.selectedBranch?.id == branch.id,
                      onTap: () =>
                          context.read<BranchCubit>().selectBranch(branch),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  const _BranchCard({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  final Branch branch;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.figma316D80 : AppColors.whiteColor;
    final textColor = isSelected ? Colors.white : AppColors.figma316D80;

    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isSelected
                      ? AppColors.figma316D80
                      : AppColors.containerBorderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(branch.name,
                    style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                if (branch.address?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(branch.address!,
                      style: GoogleFonts.inter(color: textColor, fontSize: 14)),
                ],
                if (branch.phone?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(branch.phone!,
                      style: GoogleFonts.inter(color: textColor, fontSize: 14)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState(
      {required this.message,
      required this.actionLabel,
      required this.onPressed});

  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
