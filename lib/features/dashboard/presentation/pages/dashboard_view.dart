import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/widgets/summary_card.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';
import 'package:rabbit_farm_mobileapp/core/widgets/app_state_panel.dart';
import 'package:rabbit_farm_mobileapp/features/dashboard/presentation/bloc/dashboard_event.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          switch (state.status) {
            case DashboardStatus.loading:
              return const AppStatePanel.loading();

            case DashboardStatus.error:
              return AppStatePanel(
                kind: state.failureKind == AppFailureKind.offline
                    ? AppStateKind.offline
                    : AppStateKind.error,
                message: state.errorMessage,
                onAction: () =>
                    context.read<DashboardBloc>().add(DashboardLoaded()),
              );

            case DashboardStatus.loaded:
              final summary = state.data!.summary;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  children: [
                    SummaryCard(
                      title: 'Total Rabbits',
                      value: summary.totalRabbits.toString(),
                    ),

                    SummaryCard(
                      title: 'Pregnant Rabbits',
                      value: summary.pregnantRabbits.toString(),
                    ),

                    SummaryCard(
                      title: 'Available Cages',
                      value: summary.availableCages.toString(),
                    ),

                    SummaryCard(
                      title: 'Monthly Revenue',
                      value: 'GH₵ ${summary.monthlyRevenue}',
                    ),
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
