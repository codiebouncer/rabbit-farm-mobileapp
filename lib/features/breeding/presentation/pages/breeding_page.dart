import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/breeding_bloc.dart';
import '../bloc/breeding_event.dart';
import '../bloc/breeding_state.dart';

import '../widgets/breeding_card.dart';
import '../widgets/breeding_filter_bar.dart';
import '../widgets/breeding_search_bar.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/app_state_panel.dart';

class BreedingPage extends StatelessWidget {
  const BreedingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreedingView();
  }
}

class BreedingView extends StatelessWidget {
  const BreedingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breeding')),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'breeding_fab',
        onPressed: () {
          context.push(RouteNames.addBreeding);
        },
        icon: const Icon(Icons.favorite),
        label: const Text('New Breeding'),
      ),

      body: BlocBuilder<BreedingBloc, BreedingState>(
        builder: (context, state) {
          switch (state.status) {
            case BreedingStateStatus.loading:
              return const AppStatePanel.loading();

            case BreedingStateStatus.error:
              return AppStatePanel(
                kind: state.failureKind == AppFailureKind.offline
                    ? AppStateKind.offline
                    : AppStateKind.error,
                message: state.errorMessage,
                onAction: () =>
                    context.read<BreedingBloc>().add(LoadBreedings()),
              );

            case BreedingStateStatus.loaded:
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: BreedingSearchBar(
                      onChanged: (query) {
                        context.read<BreedingBloc>().add(
                          SearchBreedings(query),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: BreedingFilterBar(
                      selected: state.selectedFilter,
                      onSelected: (filter) {
                        context.read<BreedingBloc>().add(
                          FilterBreedings(filter),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<BreedingBloc>().add(RefreshBreedings());
                      },
                      child: state.breedings.isEmpty
                          ? const AppStatePanel(kind: AppStateKind.empty)
                          : ListView.separated(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.breedings.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final breeding = state.breedings[index];

                                return BreedingCard(
                                  breeding: breeding,
                                  onTap: () {
                                    context.push(
                                      RouteNames.breedingDetails(
                                        breeding.breedingId,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
