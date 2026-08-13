import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit cubit) => cubit.state.user);
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.surfaceSubtle,
                    foregroundColor: AppColors.primary,
                    child: Text(
                      (user?.email ?? 'F').substring(0, 1).toUpperCase(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.farmName ?? 'Rabbit farm',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          user?.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _MoreItem(icon: Icons.grid_view_outlined, title: 'Cages'),
          const _MoreItem(
            icon: Icons.medical_services_outlined,
            title: 'Health records',
          ),
          const _MoreItem(icon: Icons.payments_outlined, title: 'Sales'),
          const _MoreItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
          ),
          const _MoreItem(
            icon: Icons.settings_outlined,
            title: 'Farm settings',
          ),
          const _MoreItem(
            icon: Icons.backup_outlined,
            title: 'Data backup and export',
          ),
          const _MoreItem(icon: Icons.help_outline, title: 'Help'),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need your email and password to access the farm again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _MoreItem({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: AppSpacing.touchTarget,
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {},
  );
}
