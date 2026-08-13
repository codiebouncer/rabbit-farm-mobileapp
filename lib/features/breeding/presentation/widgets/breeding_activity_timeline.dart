import 'package:flutter/material.dart';
import '../../data/models/breeding_model.dart';

class BreedingActivityTimeline extends StatelessWidget {
  final BreedingModel breeding;

  const BreedingActivityTimeline({super.key, required this.breeding});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _Activity(title: 'Breeding Recorded', completed: true),
      _Activity(
        title: 'Birth Recorded',
        completed: breeding.actualBirthDate != null,
      ),
      _Activity(title: 'Weaned', completed: breeding.weaningDate != null),
      _Activity(title: 'Separated', completed: breeding.separationDate != null),
      _Activity(title: 'Completed', completed: breeding.status == "Completed"),
    ];

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
              'Activity Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return _ActivityTile(
                  activity: activities[index],
                  isLast: index == activities.length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Activity {
  final String title;
  final bool completed;

  const _Activity({required this.title, required this.completed});
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;
  final bool isLast;

  const _ActivityTile({required this.activity, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: activity.completed
                    ? primary
                    : Colors.grey.shade300,
                child: Icon(
                  activity.completed
                      ? Icons.check
                      : Icons.radio_button_unchecked,
                  size: 14,
                  color: Colors.white,
                ),
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
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                activity.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: activity.completed
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: activity.completed
                      ? Colors.black87
                      : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
