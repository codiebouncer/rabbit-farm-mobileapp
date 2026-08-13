import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/rabbit_repository.dart';
import '../../data/models/cage_search_model.dart';
import '../../data/models/rabbit_profile.dart';
import 'rabbit_event.dart';
import 'rabbit_state.dart';

class RabbitBloc extends Bloc<RabbitEvent, RabbitState> {
  static const _pageSize = 20;
  final RabbitRepository repository;

  RabbitBloc(this.repository) : super(const RabbitState()) {
    on<LoadRabbits>(_onLoadRabbits);
    on<LoadMoreRabbits>(_onLoadMore);
    on<RefreshRabbits>(_onRefresh);
    on<SearchRabbits>(_onSearch);
    on<FilterRabbits>(_onFilter);
    on<LoadRabbitDetails>(_onLoadDetails);
    on<LoadMoveRabbit>(_onLoadMoveRabbit);
    on<CreateRabbit>(_onCreate);
    on<UpdateRabbit>(_onUpdate);
    on<MoveRabbitCage>(_onMoveCage);
    on<MarkRabbitPregnant>(_onMarkPregnant);
    on<MarkRabbitSold>(_onMarkSold);
    on<MarkRabbitDeceased>(_onMarkDeceased);
    on<ResetRabbitSubmission>(
      (event, emit) => emit(state.copyWith(clearSubmission: true)),
    );
    on<ResetRabbitAction>(
      (event, emit) => emit(state.copyWith(clearAction: true)),
    );
  }

  Future<void> _onLoadRabbits(LoadRabbits event, Emitter<RabbitState> emit) =>
      _loadFirstPage(emit, refreshing: false);

  Future<void> _onRefresh(RefreshRabbits event, Emitter<RabbitState> emit) =>
      _loadFirstPage(emit, refreshing: state.rabbits.isNotEmpty);

  Future<void> _onSearch(SearchRabbits event, Emitter<RabbitState> emit) async {
    emit(state.copyWith(searchQuery: event.query.trim()));
    await _loadFirstPage(emit, refreshing: state.rabbits.isNotEmpty);
  }

  Future<void> _onFilter(FilterRabbits event, Emitter<RabbitState> emit) async {
    emit(state.copyWith(selectedFilter: event.filter));
    await _loadFirstPage(emit, refreshing: state.rabbits.isNotEmpty);
  }

  Future<void> _loadFirstPage(
    Emitter<RabbitState> emit, {
    required bool refreshing,
  }) async {
    emit(
      state.copyWith(
        listStatus: refreshing
            ? RabbitListStatus.refreshing
            : RabbitListStatus.loading,
        loadingMore: false,
        clearListMessage: true,
      ),
    );
    try {
      final result = await repository.getPage(
        page: 1,
        pageSize: _pageSize,
        query: state.searchQuery,
        status: state.selectedFilter,
      );
      emit(
        state.copyWith(
          listStatus: RabbitListStatus.success,
          rabbits: result.items,
          page: result.page,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          loadingMore: false,
          clearListMessage: true,
        ),
      );
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        state.copyWith(
          listStatus: RabbitListStatus.failure,
          listMessage: failure.message,
          listFailureKind: failure.kind,
          loadingMore: false,
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreRabbits event,
    Emitter<RabbitState> emit,
  ) async {
    if (state.loadingMore ||
        !state.hasNextPage ||
        state.listStatus == RabbitListStatus.loading) {
      return;
    }
    emit(state.copyWith(loadingMore: true, clearListMessage: true));
    try {
      final result = await repository.getPage(
        page: state.page + 1,
        pageSize: _pageSize,
        query: state.searchQuery,
        status: state.selectedFilter,
      );
      emit(
        state.copyWith(
          listStatus: RabbitListStatus.success,
          rabbits: [...state.rabbits, ...result.items],
          page: result.page,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          loadingMore: false,
        ),
      );
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        state.copyWith(
          listStatus: RabbitListStatus.success,
          listMessage: failure.message,
          listFailureKind: failure.kind,
          loadingMore: false,
        ),
      );
    }
  }

  Future<void> _onLoadDetails(
    LoadRabbitDetails event,
    Emitter<RabbitState> emit,
  ) async {
    emit(
      state.copyWith(
        detailsStatus: RabbitDetailsStatus.loading,
        clearDetailsMessage: true,
      ),
    );
    try {
      final profile = await repository.getProfile(event.rabbitId);
      emit(
        state.copyWith(
          detailsStatus: RabbitDetailsStatus.success,
          profile: profile,
        ),
      );
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        state.copyWith(
          detailsStatus: RabbitDetailsStatus.failure,
          detailsMessage: failure.message,
          detailsFailureKind: failure.kind,
        ),
      );
    }
  }

  Future<void> _onLoadMoveRabbit(
    LoadMoveRabbit event,
    Emitter<RabbitState> emit,
  ) async {
    emit(
      state.copyWith(
        detailsStatus: RabbitDetailsStatus.loading,
        clearDetailsMessage: true,
      ),
    );
    try {
      final results = await Future.wait<dynamic>([
        repository.getProfile(event.rabbitId),
        repository.getAvailableCages(),
      ]);
      emit(
        state.copyWith(
          detailsStatus: RabbitDetailsStatus.success,
          profile: results[0] as RabbitProfile,
          availableCages: results[1] as List<CageSearchModel>,
        ),
      );
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        state.copyWith(
          detailsStatus: RabbitDetailsStatus.failure,
          detailsMessage: failure.message,
          detailsFailureKind: failure.kind,
        ),
      );
    }
  }

  Future<void> _onCreate(CreateRabbit event, Emitter<RabbitState> emit) async {
    if (state.submissionStatus == RabbitSubmissionStatus.submitting) return;
    emit(
      state.copyWith(
        submissionStatus: RabbitSubmissionStatus.submitting,
        clearSubmission: true,
      ),
    );
    try {
      final rabbit = await repository.createRabbitAndReturn(event.request);
      emit(
        state.copyWith(
          submissionStatus: RabbitSubmissionStatus.success,
          submissionMessage: 'Rabbit ${rabbit.rabbitId} created successfully.',
          createdRabbitId: rabbit.rabbitId,
        ),
      );
    } catch (error) {
      _emitSubmissionFailure(emit, error);
    }
  }

  Future<void> _onUpdate(UpdateRabbit event, Emitter<RabbitState> emit) async {
    if (state.submissionStatus == RabbitSubmissionStatus.submitting) return;
    emit(
      state.copyWith(
        submissionStatus: RabbitSubmissionStatus.submitting,
        clearSubmission: true,
      ),
    );
    try {
      final rabbit = await repository.updateRabbitAndReturn(
        event.rabbitId,
        event.request,
      );
      emit(
        state.copyWith(
          submissionStatus: RabbitSubmissionStatus.success,
          submissionMessage: 'Rabbit ${rabbit.rabbitId} updated successfully.',
          createdRabbitId: rabbit.rabbitId,
        ),
      );
    } catch (error) {
      _emitSubmissionFailure(emit, error);
    }
  }

  Future<void> _onMoveCage(
    MoveRabbitCage event,
    Emitter<RabbitState> emit,
  ) async {
    await _runAction(
      emit,
      () => repository.moveCage(event.rabbitId, event.request),
      event.rabbitId,
      'Rabbit moved successfully.',
    );
  }

  Future<void> _onMarkPregnant(
    MarkRabbitPregnant event,
    Emitter<RabbitState> emit,
  ) async {
    await _runAction(
      emit,
      () => repository.markPregnant(event.rabbitId),
      event.rabbitId,
      'Rabbit marked pregnant.',
    );
  }

  Future<void> _onMarkSold(
    MarkRabbitSold event,
    Emitter<RabbitState> emit,
  ) async {
    await _runAction(
      emit,
      () => repository.markSold(
        event.rabbitId,
        event.amount,
        event.buyerName,
        event.buyerContact,
      ),
      event.rabbitId,
      'Sale recorded successfully.',
    );
  }

  Future<void> _onMarkDeceased(
    MarkRabbitDeceased event,
    Emitter<RabbitState> emit,
  ) async {
    await _runAction(
      emit,
      () => repository.markDeceased(event.rabbitId),
      event.rabbitId,
      'Rabbit marked deceased.',
    );
  }

  Future<void> _runAction(
    Emitter<RabbitState> emit,
    Future<void> Function() operation,
    String rabbitId,
    String message,
  ) async {
    if (state.actionStatus == RabbitActionStatus.submitting) return;
    emit(
      state.copyWith(
        actionStatus: RabbitActionStatus.submitting,
        clearAction: true,
      ),
    );
    try {
      await operation();
      emit(
        state.copyWith(
          actionStatus: RabbitActionStatus.success,
          actionMessage: message,
        ),
      );
      add(LoadRabbitDetails(rabbitId));
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        state.copyWith(
          actionStatus: RabbitActionStatus.failure,
          actionMessage: failure.message,
        ),
      );
    }
  }

  void _emitSubmissionFailure(Emitter<RabbitState> emit, Object error) {
    final failure = AppException.from(error);
    emit(
      state.copyWith(
        submissionStatus: RabbitSubmissionStatus.failure,
        submissionMessage: failure.message,
        fieldErrors: failure.fieldErrors,
      ),
    );
  }
}
