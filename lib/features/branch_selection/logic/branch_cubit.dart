import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wavex/features/branch_selection/data/models/branch.dart';
import 'package:wavex/features/branch_selection/data/repository/branch_repository.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit(this._repository) : super(const BranchInitial());

  final BranchRepository _repository;

  Future<void> loadBranches(int regionId) async {
    emit(const BranchLoading());

    try {
      emit(BranchLoaded(branches: await _repository.getBranches(regionId)));
    } catch (error) {
      emit(BranchLoadFailure(error.toString()));
    }
  }

  void selectBranch(Branch branch) {
    final currentState = state;
    if (currentState is BranchLoaded) {
      emit(currentState.copyWith(selectedBranch: branch));
    }
  }

  void clearSelection() {
    emit(const BranchInitial());
  }
}
