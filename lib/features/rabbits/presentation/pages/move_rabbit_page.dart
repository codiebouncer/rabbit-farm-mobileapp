import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_state_panel.dart';
import '../../data/models/cage_search_model.dart';
import '../../data/models/move_rabbit_request.dart';
import '../bloc/rabbit_bloc.dart';
import '../bloc/rabbit_event.dart';
import '../bloc/rabbit_state.dart';

class MoveRabbitPage extends StatefulWidget {
  final String rabbitId;
  const MoveRabbitPage({required this.rabbitId, super.key});

  @override
  State<MoveRabbitPage> createState() => _MoveRabbitPageState();
}

class _MoveRabbitPageState extends State<MoveRabbitPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  CageSearchModel? _selected;
  DateTime _effectiveDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<RabbitBloc>().add(LoadMoveRabbit(widget.rabbitId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (value != null && mounted) setState(() => _effectiveDate = value);
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final selected = _selected;
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an available destination cage.')),
      );
      return;
    }
    context.read<RabbitBloc>().add(
      MoveRabbitCage(
        widget.rabbitId,
        MoveRabbitRequest(
          cageId: selected.cageId,
          effectiveDate: DateFormat('yyyy-MM-dd').format(_effectiveDate),
          reason: _optional(_reasonController.text),
          notes: _optional(_notesController.text),
        ),
      ),
    );
  }

  String? _optional(String value) => value.trim().isEmpty ? null : value.trim();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RabbitBloc, RabbitState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == RabbitActionStatus.success) {
          context.read<RabbitBloc>().add(ResetRabbitAction());
          context.pop(true);
        } else if (state.actionStatus == RabbitActionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.actionMessage ?? 'The rabbit could not be moved.',
              ),
              action: SnackBarAction(label: 'Retry', onPressed: _submit),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Move to cage')),
        body: BlocBuilder<RabbitBloc, RabbitState>(
          builder: (context, state) {
            if (state.detailsStatus == RabbitDetailsStatus.loading ||
                state.detailsStatus == RabbitDetailsStatus.initial) {
              return const AppStatePanel.loading();
            }
            if (state.detailsStatus == RabbitDetailsStatus.failure) {
              return AppStatePanel(
                kind: state.detailsFailureKind == AppFailureKind.offline
                    ? AppStateKind.offline
                    : AppStateKind.error,
                message: state.detailsMessage,
                onAction: () => context.read<RabbitBloc>().add(
                  LoadMoveRabbit(widget.rabbitId),
                ),
              );
            }
            final rabbit = state.profile?.rabbit;
            if (rabbit == null) {
              return const AppStatePanel(kind: AppStateKind.error);
            }
            final query = _searchController.text.trim().toLowerCase();
            final cages = state.availableCages
                .where((cage) => cage.cageId != rabbit.cageId)
                .where(
                  (cage) =>
                      query.isEmpty ||
                      cage.cageId.toLowerCase().contains(query) ||
                      (cage.cageType ?? '').toLowerCase().contains(query),
                )
                .toList();
            final submitting =
                state.actionStatus == RabbitActionStatus.submitting;
            return Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _CurrentCageCard(
                    cageId: rabbit.cageId ?? 'Not assigned',
                    rabbitId: rabbit.rabbitId,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Choose destination cage',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search available cages',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (cages.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Text('No available cages match this search.'),
                    )
                  else
                    ...cages.map(
                      (cage) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _CageOption(
                          cage: cage,
                          selected: _selected?.cageId == cage.cageId,
                          onTap: submitting
                              ? null
                              : () => setState(() => _selected = cage),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: submitting ? null : _selectDate,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Effective date *',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        DateFormat('d MMM yyyy').format(_effectiveDate),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _reasonController,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: 'Reason',
                      hintText: 'Weaning, capacity, treatment, or pairing',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Optional movement details',
                    ),
                  ),
                  if (state.actionStatus == RabbitActionStatus.failure) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.actionMessage ?? 'Please check the form and retry.',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Confirm move',
                    icon: Icons.swap_horiz,
                    loading: submitting,
                    onPressed: _selected == null ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CurrentCageCard extends StatelessWidget {
  final String cageId;
  final String rabbitId;
  const _CurrentCageCard({required this.cageId, required this.rabbitId});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.infoSurface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      border: Border.all(color: AppColors.info.withValues(alpha: .35)),
    ),
    child: Row(
      children: [
        const Icon(Icons.home_work_outlined, color: AppColors.info),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current cage',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                '$cageId · $rabbitId',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CageOption extends StatelessWidget {
  final CageSearchModel cage;
  final bool selected;
  final VoidCallback? onTap;
  const _CageOption({
    required this.cage,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final capacity = cage.capacity;
    final occupancy = cage.occupancy;
    final usage = capacity == null || capacity == 0 || occupancy == null
        ? null
        : occupancy / capacity;
    return Semantics(
      selected: selected,
      button: true,
      label: 'Cage ${cage.cageId}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceAccent : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: selected ? AppColors.purple : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cage.cageId,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      [
                        if (cage.cageType != null) cage.cageType,
                        if (occupancy != null && capacity != null)
                          '$occupancy of $capacity occupied',
                      ].whereType<String>().join(' · '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (usage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      LinearProgressIndicator(
                        value: usage.clamp(0, 1),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        backgroundColor: AppColors.surfaceSubtle,
                        color: usage > .8
                            ? AppColors.warning
                            : AppColors.success,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? AppColors.purple : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
