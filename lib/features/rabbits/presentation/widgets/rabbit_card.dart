import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/rabbit_model.dart';

class RabbitCard extends StatelessWidget {
  final RabbitModel rabbit;
  final VoidCallback? onTap;
  const RabbitCard({required this.rabbit, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(rabbit.status);
    final stage = rabbit.stage ?? _ageLabel(rabbit.dateOfBirth);
    return Semantics(
      button: true,
      label:
          '${rabbit.rabbitId}, ${rabbit.gender}, ${rabbit.breed ?? 'breed unknown'}, ${rabbit.status}',
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.large),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.surfaceSubtle,
                  foregroundColor: AppColors.textPrimary,
                  child: const Icon(Icons.pets_outlined),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rabbit.rabbitId,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_sexLabel(rabbit.gender)} · ${rabbit.breed ?? 'Breed unknown'}${stage == null ? '' : ' · $stage'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Cage ${rabbit.cage ?? 'unassigned'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  constraints: const BoxConstraints(minWidth: 104),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: status.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          _statusLabel(rabbit.status),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: status.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _sexLabel(String value) => switch (value.toUpperCase()) {
    'F' => 'Female',
    'M' => 'Male',
    _ => value,
  };
  static String _statusLabel(String value) =>
      value.toLowerCase() == 'dead' ? 'Deceased' : value;
  static String? _ageLabel(String? date) {
    final birthDate = DateTime.tryParse(date ?? '');
    if (birthDate == null) return null;
    final months = DateTime.now().difference(birthDate).inDays ~/ 30;
    return months < 1 ? 'Kit' : '$months mo';
  }

  static _StatusStyle _statusStyle(String value) => switch (value
      .toLowerCase()) {
    'active' => const _StatusStyle(AppColors.success, AppColors.successSurface),
    'pregnant' => const _StatusStyle(AppColors.purple, AppColors.surfaceAccent),
    'sold' => const _StatusStyle(AppColors.info, AppColors.infoSurface),
    'dead' ||
    'deceased' => const _StatusStyle(AppColors.error, AppColors.errorSurface),
    _ => const _StatusStyle(AppColors.textSecondary, AppColors.surfaceSubtle),
  };
}

class _StatusStyle {
  final Color color;
  final Color surface;
  const _StatusStyle(this.color, this.surface);
}
