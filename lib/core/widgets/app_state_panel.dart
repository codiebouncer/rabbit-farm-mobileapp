import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

enum AppStateKind { loading, empty, noResults, offline, error, success }

class AppStatePanel extends StatelessWidget {
  final AppStateKind kind;
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String actionLabel;

  const AppStatePanel({
    required this.kind,
    this.title,
    this.message,
    this.onAction,
    this.actionLabel = 'Try again',
    super.key,
  });
  const AppStatePanel.loading({super.key})
    : kind = AppStateKind.loading,
      title = 'Loading farm records',
      message = 'Please wait a moment.',
      onAction = null,
      actionLabel = 'Try again';

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Semantics(
      liveRegion: kind == AppStateKind.error || kind == AppStateKind.success,
      label: '${title ?? data.title}. ${message ?? data.message}',
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kind == AppStateKind.loading)
                      const CircularProgressIndicator()
                    else
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: data.surface,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                        ),
                        child: Icon(data.icon, color: data.color, size: 28),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title ?? data.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      message ?? data.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (onAction != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(label: actionLabel, onPressed: onAction),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _StateData get _data => switch (kind) {
    AppStateKind.loading => const _StateData(
      Icons.hourglass_empty,
      AppColors.purple,
      AppColors.surfaceAccent,
      'Loading farm records',
      'Please wait a moment.',
    ),
    AppStateKind.empty => const _StateData(
      Icons.inventory_2_outlined,
      AppColors.burntOrange,
      AppColors.surfaceSubtle,
      'Nothing here yet',
      'Add your first record to get started.',
    ),
    AppStateKind.noResults => const _StateData(
      Icons.search_off,
      AppColors.purple,
      AppColors.surfaceAccent,
      'No matching results',
      'Try a different search or clear the filters.',
    ),
    AppStateKind.offline => const _StateData(
      Icons.cloud_off_outlined,
      AppColors.warning,
      AppColors.warningSurface,
      'You are offline',
      'Check your connection, then try again.',
    ),
    AppStateKind.error => const _StateData(
      Icons.error_outline,
      AppColors.error,
      AppColors.errorSurface,
      'We could not load this',
      'Please retry. Your existing records are safe.',
    ),
    AppStateKind.success => const _StateData(
      Icons.check_circle_outline,
      AppColors.success,
      AppColors.successSurface,
      'Saved successfully',
      'Your farm record has been updated.',
    ),
  };
}

class _StateData {
  final IconData icon;
  final Color color;
  final Color surface;
  final String title;
  final String message;
  const _StateData(
    this.icon,
    this.color,
    this.surface,
    this.title,
    this.message,
  );
}
