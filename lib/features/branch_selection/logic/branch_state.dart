part of 'branch_cubit.dart';

sealed class BranchState {
  const BranchState();
}

class BranchInitial extends BranchState {
  const BranchInitial();
}

class BranchLoading extends BranchState {
  const BranchLoading();
}

class BranchLoaded extends BranchState {
  const BranchLoaded({required this.branches, this.selectedBranch});

  final List<Branch> branches;
  final Branch? selectedBranch;

  BranchLoaded copyWith({Branch? selectedBranch}) {
    return BranchLoaded(branches: branches, selectedBranch: selectedBranch);
  }
}

class BranchLoadFailure extends BranchState {
  const BranchLoadFailure(this.message);

  final String message;
}
