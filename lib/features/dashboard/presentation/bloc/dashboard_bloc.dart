import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc(this.repository) : super(const DashboardState()) {
    on<DashboardLoaded>(_onDashboardLoaded);
  }

  Future<void> _onDashboardLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DashboardStatus.loading));

      final dashboard = await repository.loadDashboard();

      emit(state.copyWith(status: DashboardStatus.loaded, data: dashboard));
    } catch (e) {
      final failure = AppException.from(e);
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
          failureKind: failure.kind,
        ),
      );
    }
  }
}
