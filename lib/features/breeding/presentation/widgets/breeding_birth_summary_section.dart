import 'package:flutter/material.dart';

import '../../data/models/breeding_model.dart';

class BreedingBirthSummarySection extends StatelessWidget {
  final BreedingModel breeding;

  const BreedingBirthSummarySection({super.key, required this.breeding});

  @override
  Widget build(BuildContext context) {
    if (breeding.actualBirthDate == null) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey),
              SizedBox(width: 12),
              Expanded(child: Text("Birth has not been recorded yet.")),
            ],
          ),
        ),
      );
    }

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
              "Birth Summary",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                _SummaryCard(
                  title: "Kits Born",
                  value: breeding.kitsBorn.toString(),
                  icon: Icons.child_friendly,
                  color: Colors.blue,
                ),
                _SummaryCard(
                  title: "Alive",
                  value: breeding.activeBorn.toString(),
                  icon: Icons.favorite,
                  color: Colors.green,
                ),
                _SummaryCard(
                  title: "Deaths",
                  value: breeding.deaths.toString(),
                  icon: Icons.close,
                  color: Colors.red,
                ),
                _SummaryCard(
                  title: "Male",
                  value: breeding.maleBorn.toString(),
                  icon: Icons.male,
                  color: Colors.indigo,
                ),
                _SummaryCard(
                  title: "Female",
                  value: breeding.femaleBorn.toString(),
                  icon: Icons.female,
                  color: Colors.pink,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(title, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
