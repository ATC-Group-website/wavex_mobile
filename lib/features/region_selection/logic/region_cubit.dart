import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wavex/core/constants/cache_keys.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';

import '../data/models/country.dart';
import '../data/repository/region_repository.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  RegionCubit(this._repository) : super(const RegionInitial());

  final RegionRepository _repository;

  Future<void> loadRegions() async {
    emit(const RegionLoading());

    try {
      emit(RegionLoaded(regions: await _repository.getRegions()));
    } catch (error) {
      emit(RegionLoadFailure(error.toString()));
    }
  }

  void selectRegion(Country country) {
    final currentState = state;
    if (currentState is RegionLoaded) {
      emit(currentState.copyWith(selectedRegion: country));
    }
  }

  Future<void> confirmSelection() async {
    final currentState = state;
    if (currentState is! RegionLoaded || currentState.selectedRegion == null) {
      return;
    }

    emit(RegionSaving(currentState));

    try {
      final region = currentState.selectedRegion!;
      final results = await Future.wait([
        CacheHelper.saveData(
          key: CacheKeys.selectedCountryId,
          value: region.id,
        ),
        CacheHelper.saveData(
          key: CacheKeys.selectedCountryName,
          value: region.name,
        ),
        CacheHelper.saveData(
          key: CacheKeys.selectedCountryIsoCode,
          value: region.isoCode,
        ),
        CacheHelper.saveData(
          key: CacheKeys.selectedCurrencyCode,
          value: region.currencyCode,
        ),
      ]);

      if (results.any((wasSaved) => !wasSaved)) {
        throw Exception('Could not save the selected region.');
      }

      emit(RegionSaved(currentState));
    } catch (error) {
      emit(RegionSaveFailure(currentState, error.toString()));
    }
  }
}
