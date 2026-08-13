import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/breeding_model.dart';

class BreedingTimelineSection extends StatelessWidget {
  final BreedingModel breeding;

  const BreedingTimelineSection({super.key, required this.breeding});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Breeding Timeline",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _TimelineTile(
              icon: Icons.favorite,
              title: "Crossing Date",
              value: _formatDate(breeding.crossingDate),
              isCompleted: true,
            ),

            _TimelineTile(
              icon: Icons.calendar_today,
              title: "Expected Birth",
              value: _formatDate(breeding.expectedBirthDate),
              isCompleted: true,
            ),

            _TimelineTile(
              icon: Icons.child_friendly,
              title: "Actual Birth",
              value: breeding.actualBirthDate != null
                  ? _formatDate(breeding.actualBirthDate!)
                  : "Pending",
              isCompleted: breeding.actualBirthDate != null,
            ),

            _TimelineTile(
              icon: Icons.pets,
              title: "Weaning",
              value: breeding.weaningDate != null
                  ? _formatDate(breeding.weaningDate!)
                  : "Pending",
              isCompleted: breeding.weaningDate != null,
            ),

            _TimelineTile(
              icon: Icons.call_split,
              title: "Separation",
              value: breeding.separationDate != null
                  ? _formatDate(breeding.separationDate!)
                  : "Pending",
              isCompleted: breeding.separationDate != null,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}

class _TimelineTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isCompleted;
  final bool isLast;

  const _TimelineTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Colors.grey.shade400;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isCompleted ? activeColor : inactiveColor,
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isCompleted
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
