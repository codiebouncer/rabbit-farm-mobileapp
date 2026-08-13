import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_state_panel.dart';
import '../../data/models/rabbit_details_model.dart';
import '../../data/models/rabbit_history_models.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_profile.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';
import '../widgets/mark_sold_dialog.dart';

class RabbitDetailsPage extends StatefulWidget {
  final String rabbitId;
  const RabbitDetailsPage({required this.rabbitId, super.key});

  @override
  State<RabbitDetailsPage> createState() => _RabbitDetailsPageState();
}

class _RabbitDetailsPageState extends State<RabbitDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RabbitBloc>().add(LoadRabbitDetails(widget.rabbitId));
  }

  Future<void> _recordSale(RabbitDetailsModel rabbit) async {
    final result = await showDialog<MarkSoldResult>(
      context: context,
      builder: (_) => const MarkSoldDialog(),
    );
    if (result == null || !mounted) return;
    context.read<RabbitBloc>().add(
      MarkRabbitSold(
        rabbit.rabbitId,
        result.amount,
        result.buyerName,
        result.buyerContact,
      ),
    );
  }

  Future<void> _confirmDeceased(RabbitDetailsModel rabbit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
        title: const Text('Mark rabbit as deceased?'),
        content: Text(
          '${rabbit.rabbitId} will be removed from active farm operations. '
          'This status change should only be used after the death has been confirmed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Mark deceased'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<RabbitBloc>().add(MarkRabbitDeceased(rabbit.rabbitId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RabbitBloc, RabbitState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == RabbitActionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionMessage ?? 'Rabbit updated.')),
          );
          context.read<RabbitBloc>().add(ResetRabbitAction());
        } else if (state.actionStatus == RabbitActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionMessage ?? 'The update failed.'),
              action: SnackBarAction(
                label: 'Retry load',
                onPressed: () => context.read<RabbitBloc>().add(
                  LoadRabbitDetails(widget.rabbitId),
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rabbit details'),
          actions: [
            IconButton(
              tooltip: 'Edit rabbit',
              onPressed: () async {
                final updated = await context.push<bool>(
                  RouteNames.editRabbit(widget.rabbitId),
                );
                if (updated == true && context.mounted) {
                  context.read<RabbitBloc>().add(
                    LoadRabbitDetails(widget.rabbitId),
                  );
                }
              },
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: BlocBuilder<RabbitBloc, RabbitState>(
          builder: (context, state) {
            if ((state.detailsStatus == RabbitDetailsStatus.loading ||
                    state.detailsStatus == RabbitDetailsStatus.initial) &&
                state.profile == null) {
              return const AppStatePanel.loading();
            }
            if (state.detailsStatus == RabbitDetailsStatus.failure &&
                state.profile == null) {
              return AppStatePanel(
                kind: state.detailsFailureKind == AppFailureKind.offline
                    ? AppStateKind.offline
                    : AppStateKind.error,
                message: state.detailsMessage,
                onAction: () => context.read<RabbitBloc>().add(
                  LoadRabbitDetails(widget.rabbitId),
                ),
              );
            }
            final profile = state.profile;
            if (profile == null) {
              return const AppStatePanel(kind: AppStateKind.error);
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RabbitBloc>().add(
                  LoadRabbitDetails(widget.rabbitId),
                );
              },
              child: _RabbitProfileView(
                profile: profile,
                actionInProgress:
                    state.actionStatus == RabbitActionStatus.submitting,
                onSale: () => _recordSale(profile.rabbit),
                onDeceased: () => _confirmDeceased(profile.rabbit),
                onPregnant: () => context.read<RabbitBloc>().add(
                  MarkRabbitPregnant(profile.rabbit.rabbitId),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RabbitProfileView extends StatelessWidget {
  final RabbitProfile profile;
  final bool actionInProgress;
  final VoidCallback onSale;
  final VoidCallback onDeceased;
  final VoidCallback onPregnant;
  const _RabbitProfileView({
    required this.profile,
    required this.actionInProgress,
    required this.onSale,
    required this.onDeceased,
    required this.onPregnant,
  });

  @override
  Widget build(BuildContext context) {
    final rabbit = profile.rabbit;
    final inactive = rabbit.status == 'Sold' || rabbit.status == 'Dead';
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _HeroCard(rabbit: rabbit),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: actionInProgress
                    ? null
                    : () async {
                        final updated = await context.push<bool>(
                          RouteNames.editRabbit(rabbit.rabbitId),
                        );
                        if (updated == true && context.mounted) {
                          context.read<RabbitBloc>().add(
                            LoadRabbitDetails(rabbit.rabbitId),
                          );
                        }
                      },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: actionInProgress || inactive
                    ? null
                    : () async {
                        final moved = await context.push<bool>(
                          RouteNames.moveRabbit(rabbit.rabbitId),
                        );
                        if (moved == true && context.mounted) {
                          context.read<RabbitBloc>().add(
                            LoadRabbitDetails(rabbit.rabbitId),
                          );
                        }
                      },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Move cage'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _SectionCard(
          title: 'Profile',
          icon: Icons.badge_outlined,
          children: [
            _DetailRow(label: 'Sex', value: _sex(rabbit.gender)),
            _DetailRow(
              label: 'Breed',
              value: rabbit.breedName ?? 'Not recorded',
            ),
            _DetailRow(label: 'Age', value: _age(rabbit.dateOfBirth)),
            _DetailRow(label: 'Stage', value: rabbit.stage ?? 'Not recorded'),
            _DetailRow(label: 'Cage', value: rabbit.cageId ?? 'Not assigned'),
            _DetailRow(
              label: 'Color / markings',
              value: rabbit.colorMarkings ?? 'Not recorded',
            ),
            _DetailRow(
              label: 'Supplier',
              value: rabbit.supplierName ?? 'Farm bred',
            ),
            if (rabbit.notes != null)
              _DetailRow(label: 'Notes', value: rabbit.notes ?? ''),
          ],
        ),
        _SectionCard(
          title: 'Parentage',
          icon: Icons.account_tree_outlined,
          children: [
            _DetailRow(label: 'Dam', value: rabbit.motherRabbitId ?? 'Unknown'),
            _DetailRow(
              label: 'Sire',
              value: rabbit.fatherRabbitId ?? 'Unknown',
            ),
          ],
        ),
        _SectionCard(
          title: 'Health history',
          icon: Icons.health_and_safety_outlined,
          count: profile.healthHistory.length,
          children: profile.healthHistory.isEmpty
              ? const [
                  _EmptySection(message: 'No health records for this rabbit.'),
                ]
              : profile.healthHistory
                    .map((record) => _HealthTile(record: record))
                    .toList(),
        ),
        _SectionCard(
          title: 'Breeding history',
          icon: Icons.favorite_border,
          count: profile.breedingHistory.length,
          children: profile.breedingHistory.isEmpty
              ? const [_EmptySection(message: 'No breeding records yet.')]
              : profile.breedingHistory
                    .map((record) => _BreedingTile(record: record))
                    .toList(),
        ),
        _SectionCard(
          title: 'Offspring',
          icon: Icons.pets_outlined,
          count: profile.offspring.length,
          children: profile.offspring.isEmpty
              ? const [_EmptySection(message: 'No offspring recorded.')]
              : profile.offspring
                    .map((offspring) => _OffspringTile(rabbit: offspring))
                    .toList(),
        ),
        _SectionCard(
          title: 'Sales history',
          icon: Icons.payments_outlined,
          count: profile.salesHistory.length,
          children: profile.salesHistory.isEmpty
              ? const [
                  _EmptySection(message: 'No sales record for this rabbit.'),
                ]
              : profile.salesHistory
                    .map((sale) => _SaleTile(sale: sale))
                    .toList(),
        ),
        _SectionCard(
          title: 'Cage movement history',
          icon: Icons.swap_horiz,
          count: profile.cageMovements.length,
          children: profile.cageMovements.isEmpty
              ? const [_EmptySection(message: 'No cage movements recorded.')]
              : profile.cageMovements
                    .map((movement) => _MovementTile(movement: movement))
                    .toList(),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Farm actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        if (rabbit.gender.toUpperCase().startsWith('F') &&
            rabbit.status == 'Active')
          OutlinedButton.icon(
            onPressed: actionInProgress ? null : onPregnant,
            icon: const Icon(Icons.favorite_outline),
            label: const Text('Mark pregnant'),
          ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: actionInProgress || inactive ? null : onSale,
          icon: const Icon(Icons.sell_outlined),
          label: const Text('Mark sold'),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
          ),
          onPressed: actionInProgress || inactive ? null : onDeceased,
          icon: const Icon(Icons.warning_amber_rounded),
          label: const Text('Mark deceased'),
        ),
        if (actionInProgress) ...[
          const SizedBox(height: AppSpacing.md),
          const Center(child: CircularProgressIndicator()),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final RabbitDetailsModel rabbit;
  const _HeroCard({required this.rabbit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadius.panel),
    ),
    child: Row(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Text(
            rabbit.rabbitId.characters.take(2).toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rabbit.rabbitId,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${rabbit.breedName ?? 'Breed not recorded'} · ${_sex(rabbit.gender)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textInverse.withValues(alpha: .82),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _StatusBadge(status: rabbit.status),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? count;
  final List<Widget> children;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.count,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAccent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text('$count'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._withDividers(children),
        ],
      ),
    ),
  );

  List<Widget> _withDividers(List<Widget> values) {
    final result = <Widget>[];
    for (var index = 0; index < values.length; index++) {
      result.add(values[index]);
      if (index < values.length - 1) result.add(const Divider(height: 24));
    }
    return result;
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      children: [
        const Icon(
          Icons.inbox_outlined,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    ),
  );
}

class _HealthTile extends StatelessWidget {
  final RabbitHealthRecord record;
  const _HealthTile({required this.record});

  @override
  Widget build(BuildContext context) => _HistoryTile(
    title: record.treatment,
    subtitle: [
      _formatDate(record.treatmentDate),
      if (record.notes != null) record.notes,
    ].whereType<String>().join(' · '),
    trailing: NumberFormat.currency(
      symbol: 'GH₵ ',
      decimalDigits: 2,
    ).format(record.cost),
  );
}

class _BreedingTile extends StatelessWidget {
  final RabbitBreedingRecord record;
  const _BreedingTile({required this.record});

  @override
  Widget build(BuildContext context) => _HistoryTile(
    title: '${record.doeRabbitId} × ${record.buckRabbitId}',
    subtitle:
        'Crossed ${_formatDate(record.crossingDate)}${record.kitsBorn == null ? '' : ' · ${record.kitsBorn} kits'}',
    trailing: record.status ?? 'Recorded',
  );
}

class _OffspringTile extends StatelessWidget {
  final RabbitModel rabbit;
  const _OffspringTile({required this.rabbit});

  @override
  Widget build(BuildContext context) => _HistoryTile(
    title: rabbit.rabbitId,
    subtitle:
        '${rabbit.breed ?? 'Breed not recorded'} · ${_sex(rabbit.gender)}',
    trailing: rabbit.status == 'Dead' ? 'Deceased' : rabbit.status,
  );
}

class _SaleTile extends StatelessWidget {
  final RabbitSaleRecord sale;
  const _SaleTile({required this.sale});

  @override
  Widget build(BuildContext context) => _HistoryTile(
    title: sale.buyerName,
    subtitle: _formatDate(sale.saleDate),
    trailing: NumberFormat.currency(
      symbol: 'GH₵ ',
      decimalDigits: 2,
    ).format(sale.amount),
  );
}

class _MovementTile extends StatelessWidget {
  final RabbitCageMovementRecord movement;
  const _MovementTile({required this.movement});

  @override
  Widget build(BuildContext context) => _HistoryTile(
    title: '${movement.fromCageId ?? 'Farm entry'} → ${movement.toCageId}',
    subtitle: [
      _formatDate(movement.effectiveDate),
      movement.reason,
      movement.notes,
    ].whereType<String>().join(' · '),
  );
}

class _HistoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  const _HistoryTile({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      if (trailing != null) ...[
        const SizedBox(width: AppSpacing.sm),
        Text(
          trailing ?? '',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.purple,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status == 'Dead' ? 'Deceased' : status;
    final colors = switch (normalized) {
      'Active' => (AppColors.successSurface, AppColors.success),
      'Pregnant' => (AppColors.surfaceAccent, AppColors.purple),
      'Sold' => (AppColors.infoSurface, AppColors.info),
      'Deceased' => (AppColors.errorSurface, AppColors.error),
      _ => (AppColors.surfaceSubtle, AppColors.primary),
    };
    return Semantics(
      label: 'Status: $normalized',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: colors.$1,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          normalized,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.$2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

String _sex(String value) => switch (value.toUpperCase()) {
  'F' || 'FEMALE' => 'Female',
  'M' || 'MALE' => 'Male',
  _ => value,
};

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  return date == null ? value : DateFormat('d MMM yyyy').format(date);
}

String _age(String? dateOfBirth) {
  if (dateOfBirth == null) return 'Not recorded';
  final birth = DateTime.tryParse(dateOfBirth);
  if (birth == null) return 'Not recorded';
  final now = DateTime.now();
  final months = (now.year - birth.year) * 12 + now.month - birth.month;
  if (months < 1) return '${now.difference(birth).inDays} days';
  if (months < 12) return '$months months';
  final years = months ~/ 12;
  final remainingMonths = months % 12;
  return remainingMonths == 0
      ? '$years ${years == 1 ? 'year' : 'years'}'
      : '$years ${years == 1 ? 'year' : 'years'}, $remainingMonths mo';
}
