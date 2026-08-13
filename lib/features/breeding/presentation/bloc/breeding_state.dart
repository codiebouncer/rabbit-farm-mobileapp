import 'package:equatable/equatable.dart';

import '../../data/models/breeding_model.dart';
import '../../../../core/errors/app_exception.dart';

enum BreedingStateStatus { initial, loading, loaded, error }

class BreedingState extends Equatable {
  final BreedingStateStatus status;

  final List<BreedingModel> breedings;

  final BreedingModel? selectedBreeding;

  final String selectedFilter;

  final String? errorMessage;
  final AppFailureKind? failureKind;

  const BreedingState({
    this.status = BreedingStateStatus.initial,
    this.breedings = const [],
    this.selectedBreeding,
    this.selectedFilter = 'All',
    this.errorMessage,
    this.failureKind,
  });

  BreedingState copyWith({
    BreedingStateStatus? status,
    List<BreedingModel>? breedings,
    BreedingModel? selectedBreeding,
    String? selectedFilter,
    String? errorMessage,
    AppFailureKind? failureKind,
  }) {
    return BreedingState(
      status: status ?? this.status,
      breedings: breedings ?? this.breedings,
      selectedBreeding: selectedBreeding ?? this.selectedBreeding,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage ?? this.errorMessage,
      failureKind: failureKind ?? this.failureKind,
    );
  }

  @override
  List<Object?> get props => [
    status,
    breedings,
    selectedBreeding,
    selectedFilter,
    errorMessage,
    failureKind,
  ];
}
