import 'package:equatable/equatable.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/data/models/dashboard_data.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;

  final DashboardData? data;

  final String? errorMessage;
  final AppFailureKind? failureKind;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.errorMessage,
    this.failureKind,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? errorMessage,
    AppFailureKind? failureKind,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      failureKind: failureKind ?? this.failureKind,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage, failureKind];
}
