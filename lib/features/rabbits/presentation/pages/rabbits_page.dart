import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_state_panel.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';
import '../widgets/rabbit_card.dart';
import '../widgets/rabbit_filter_bar.dart';

class RabbitsPage extends StatefulWidget {
  const RabbitsPage({super.key});
  @override
  State<RabbitsPage> createState() => _RabbitsPageState();
}

class _RabbitsPageState extends State<RabbitsPage> {
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 280) {
      context.read<RabbitBloc>().add(LoadMoreRabbits());
    }
  }

  void _search(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<RabbitBloc>().add(SearchRabbits(value));
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabbits'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'rabbit_fab',
        tooltip: 'Add rabbit',
        onPressed: () => context.push(RouteNames.addRabbit),
        child: const Icon(Icons.add),
      ),
      body: BlocListener<RabbitBloc, RabbitState>(
        listenWhen: (previous, current) =>
            previous.listMessage != current.listMessage &&
            current.listMessage != null &&
            current.rabbits.isNotEmpty,
        listener: (context, state) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.listMessage!))),
        child: BlocBuilder<RabbitBloc, RabbitState>(
          builder: (context, state) {
            if (state.listStatus == RabbitListStatus.loading &&
                state.rabbits.isEmpty) {
              return const _RabbitListSkeleton();
            }
            if (state.listStatus == RabbitListStatus.failure &&
                state.rabbits.isEmpty) {
              return AppStatePanel(
                kind: state.listFailureKind == AppFailureKind.offline
                    ? AppStateKind.offline
                    : AppStateKind.error,
                message: state.listMessage,
                onAction: () => context.read<RabbitBloc>().add(LoadRabbits()),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<RabbitBloc>()..add(RefreshRabbits());
                await bloc.stream.firstWhere(
                  (next) => next.listStatus != RabbitListStatus.refreshing,
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: TextField(
                        onChanged: _search,
                        decoration: const InputDecoration(
                          hintText: 'Search by code, breed or cage',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: Icon(Icons.filter_list),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: RabbitFilterBar(
                        selected: state.selectedFilter,
                        onSelected: (filter) => context.read<RabbitBloc>().add(
                          FilterRabbits(filter),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${state.totalCount} rabbits',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            'Sort: code',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppColors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.rabbits.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppStatePanel(
                        kind:
                            state.searchQuery.isEmpty &&
                                state.selectedFilter == 'All'
                            ? AppStateKind.empty
                            : AppStateKind.noResults,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      sliver: SliverList.separated(
                        itemCount: state.rabbits.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final rabbit = state.rabbits[index];
                          return RabbitCard(
                            rabbit: rabbit,
                            onTap: () => context.push(
                              RouteNames.rabbitDetails(rabbit.rabbitId),
                            ),
                          );
                        },
                      ),
                    ),
                  if (state.rabbits.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: state.loadingMore
                              ? const SizedBox.square(
                                  dimension: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : state.hasNextPage
                              ? OutlinedButton(
                                  onPressed: () => context
                                      .read<RabbitBloc>()
                                      .add(LoadMoreRabbits()),
                                  child: const Text('Load more rabbits'),
                                )
                              : Text(
                                  'All ${state.totalCount} rabbits loaded',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RabbitListSkeleton extends StatelessWidget {
  const _RabbitListSkeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.md),
    children: [
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      for (var index = 0; index < 5; index++) ...[
        Container(
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ],
  );
}
