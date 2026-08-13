import 'package:flutter/material.dart';

class BreedingStatusBanner extends StatelessWidget {
  final String status;

  const BreedingStatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _statusData(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withValues(alpha: .25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: data.color,
            child: Icon(data.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Breeding Status",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: data.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _BreedingStatusData _statusData(String status) {
    switch (status) {
      case 'Separated':
        return const _BreedingStatusData(
          title: "Separated",
          color: Colors.blue,
          backgroundColor: Color(0xFFEAF3FF),
          icon: Icons.event_available_rounded,
        );

      case "Weaned":
        return const _BreedingStatusData(
          title: "Weaned",
          color: Colors.indigo,
          backgroundColor: Color(0xFFECEFFF),
          icon: Icons.pets,
        );

      case "Delivered":
        return const _BreedingStatusData(
          title: "Delivered",
          color: Colors.grey,
          backgroundColor: Color(0xFFF3F3F3),
          icon: Icons.check_circle,
        );
      case "Pregnant":
        return const _BreedingStatusData(
          title: "Pregnant",
          color: Colors.orange,
          backgroundColor: Color(0xFFFFF3E0),
          icon: Icons.pregnant_woman,
        );
      default:
        return const _BreedingStatusData(
          title: "Unknown",
          color: Colors.grey,
          backgroundColor: Color(0xFFF5F5F5),
          icon: Icons.help_outline,
        );
    }
  }
}

class _BreedingStatusData {
  final String title;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  const _BreedingStatusData({
    required this.title,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });
}
