part of 'region_cubit.dart';

sealed class RegionState {
  const RegionState();
}

class RegionInitial extends RegionState {
  const RegionInitial();
}

class RegionLoading extends RegionState {
  const RegionLoading();
}

class RegionLoaded extends RegionState {
  const RegionLoaded({required this.regions, this.selectedRegion});

  final List<Country> regions;
  final Country? selectedRegion;

  RegionLoaded copyWith({Country? selectedRegion}) {
    return RegionLoaded(regions: regions, selectedRegion: selectedRegion);
  }
}

class RegionLoadFailure extends RegionState {
  const RegionLoadFailure(this.message);

  final String message;
}

class RegionSaving extends RegionState {
  const RegionSaving(this.loadedState);

  final RegionLoaded loadedState;
}

class RegionSaved extends RegionState {
  const RegionSaved(this.loadedState);

  final RegionLoaded loadedState;
}

class RegionSaveFailure extends RegionState {
  const RegionSaveFailure(this.loadedState, this.message);

  final RegionLoaded loadedState;
  final String message;
}
