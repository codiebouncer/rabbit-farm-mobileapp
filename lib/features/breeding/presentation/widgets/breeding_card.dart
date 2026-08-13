import 'package:flutter/material.dart';

import '../../data/models/breeding_model.dart';

class BreedingCard extends StatelessWidget {
  final BreedingModel breeding;

  final VoidCallback? onTap;

  const BreedingCard({super.key, required this.breeding, this.onTap});

  Color _statusColor() {
    switch (breeding.status) {
      case 'Pregnant':
        return Colors.green;

      case 'Delivered':
        return Colors.blue;

      case 'Weaned':
        return Colors.orange;

      case 'Separated':
        return Colors.purple;

      case 'Overdue':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon() {
    switch (breeding.status) {
      case 'Pregnant':
        return Icons.favorite;

      case 'Delivered':
        return Icons.child_care;

      case 'Weaned':
        return Icons.pets;

      case 'Separated':
        return Icons.call_split;

      case 'Overdue':
        return Icons.warning_amber;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink.shade100,
                    child: const Icon(Icons.favorite, color: Colors.pink),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          breeding.breedingId,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        Text(
                          breeding.status,
                          style: TextStyle(
                            color: _statusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.chevron_right, color: Colors.grey.shade600),
                ],
              ),

              const Divider(height: 30),

              Row(
                children: [
                  const Icon(Icons.female, size: 18),

                  const SizedBox(width: 8),

                  const Text(
                    'Doe',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const Spacer(),

                  Text(breeding.doeRabbitId),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.male, size: 18),

                  const SizedBox(width: 8),

                  const Text(
                    'Buck',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const Spacer(),

                  Text(breeding.buckRabbitId),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      title: 'Crossed',
                      value: breeding.crossingDate.toString(),
                    ),
                  ),

                  Expanded(
                    child: _InfoTile(
                      title: 'Expected',
                      value: breeding.expectedBirthDate.toString(),
                    ),
                  ),
                ],
              ),

              if (breeding.actualBirthDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          title: 'Actual Birth',
                          value: breeding.actualBirthDate!.toString(),
                        ),
                      ),

                      Expanded(
                        child: _InfoTile(
                          title: 'Alive Kits',
                          value: breeding.activeBorn?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  avatar: Icon(_statusIcon(), color: Colors.white, size: 18),
                  label: Text(breeding.status),
                  backgroundColor: _statusColor(),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;

  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),

        const SizedBox(height: 4),

        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
