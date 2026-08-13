import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/data/repository/breeding_repository.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';

import 'breeding_event.dart';
import 'breeding_state.dart';

class BreedingBloc extends Bloc<BreedingEvent, BreedingState> {
  final BreedingRepository repository;

  BreedingBloc(this.repository) : super(const BreedingState()) {
    on<LoadBreedings>(_onLoadBreedings);

    on<RefreshBreedings>(_onRefresh);

    on<FilterBreedings>(_onFilter);

    on<LoadBreedingDetails>(_onLoadDetails);

    on<CreateBreeding>(_onCreate);

    on<UpdateBreeding>(_onUpdate);

    on<DeleteBreeding>(_onDelete);

    on<RecordBirth>(_onRecordBirth);

    on<RecordWeaning>(_onRecordWeaning);

    on<RecordSeparation>(_onRecordSeparation);
  }

  Future<void> _onLoadBreedings(
    LoadBreedings event,
    Emitter<BreedingState> emit,
  ) async {
    emit(state.copyWith(status: BreedingStateStatus.loading));

    try {
      final breedings = await repository.getAll();

      emit(
        state.copyWith(
          status: BreedingStateStatus.loaded,
          breedings: breedings,
        ),
      );
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onRefresh(
    RefreshBreedings event,
    Emitter<BreedingState> emit,
  ) async {
    add(LoadBreedings());
  }

  Future<void> _onFilter(
    FilterBreedings event,
    Emitter<BreedingState> emit,
  ) async {
    emit(state.copyWith(status: BreedingStateStatus.loading));

    try {
      switch (event.filter) {
        case 'Pregnant':
          emit(
            state.copyWith(
              status: BreedingStateStatus.loaded,
              breedings: await repository.getPregnant(),
              selectedFilter: event.filter,
            ),
          );
          break;

        case 'Due Soon':
          emit(
            state.copyWith(
              status: BreedingStateStatus.loaded,
              breedings: await repository.getDueSoon(),
              selectedFilter: event.filter,
            ),
          );
          break;

        case 'Overdue':
          emit(
            state.copyWith(
              status: BreedingStateStatus.loaded,
              breedings: await repository.getOverdue(),
              selectedFilter: event.filter,
            ),
          );
          break;

        case 'Recent Births':
          emit(
            state.copyWith(
              status: BreedingStateStatus.loaded,
              breedings: await repository.getRecentBirths(),
              selectedFilter: event.filter,
            ),
          );
          break;

        default:
          emit(
            state.copyWith(
              status: BreedingStateStatus.loaded,
              breedings: await repository.getAll(),
              selectedFilter: 'All',
            ),
          );
      }
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onLoadDetails(
    LoadBreedingDetails event,
    Emitter<BreedingState> emit,
  ) async {
    emit(state.copyWith(status: BreedingStateStatus.loading));

    try {
      final breeding = await repository.getById(event.breedingId);

      emit(
        state.copyWith(
          status: BreedingStateStatus.loaded,
          selectedBreeding: breeding,
        ),
      );
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onCreate(
    CreateBreeding event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.createBreeding(event.request);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onUpdate(
    UpdateBreeding event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.updateBreeding(event.breedingId, event.request);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onDelete(
    DeleteBreeding event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.deleteBreeding(event.breedingId);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onRecordBirth(
    RecordBirth event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.recordBirth(event.breedingId, event.request);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onRecordWeaning(
    RecordWeaning event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.recordWeaning(event.breedingId, event.request);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  Future<void> _onRecordSeparation(
    RecordSeparation event,
    Emitter<BreedingState> emit,
  ) async {
    try {
      await repository.recordSeparation(event.breedingId, event.request);
      add(LoadBreedings());
    } catch (e) {
      _emitFailure(emit, e);
    }
  }

  void _emitFailure(Emitter<BreedingState> emit, Object error) {
    final failure = AppException.from(error);
    emit(
      state.copyWith(
        status: BreedingStateStatus.error,
        errorMessage: failure.message,
        failureKind: failure.kind,
      ),
    );
  }
}
