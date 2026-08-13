import 'package:flutter/material.dart';

import '../../data/models/breeding_model.dart';

class BreedingRabbitInfoSection extends StatelessWidget {
  final BreedingModel breeding;

  const BreedingRabbitInfoSection({super.key, required this.breeding});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Parents", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        _RabbitCard(
          title: "Doe",
          rabbitId: breeding.doeRabbitId,
          breed: breeding.doeBreed,
          isDoe: true,
          onTap: () {
            // Navigate to Doe details
          },
        ),

        const SizedBox(height: 12),

        _RabbitCard(
          title: "Buck",
          rabbitId: breeding.buckRabbitId,
          breed: breeding.buckBreed,
          isDoe: false,
          onTap: () {
            // Navigate to Buck details
          },
        ),
      ],
    );
  }
}

class _RabbitCard extends StatelessWidget {
  final String title;
  final String rabbitId;
  final String breed;
  final VoidCallback? onTap;
  final bool isDoe;

  const _RabbitCard({
    required this.title,
    required this.rabbitId,
    required this.breed,
    required this.isDoe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isDoe
                    ? Colors.pink.shade100
                    : Colors.blue.shade100,
                child: Icon(
                  Icons.pets,
                  color: isDoe ? Colors.pink : Colors.blue,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium),

                    const SizedBox(height: 4),

                    Text(
                      rabbitId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      breed,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
