import 'package:flutter/material.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/record_birth_sheet.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/record_separation_sheet.dart';
import 'package:rabbit_farm_mobileapp/features/breeding/presentation/widgets/record_weaning_sheet.dart';

import '../../data/models/breeding_model.dart';

class BreedingPrimaryActionButton extends StatelessWidget {
  final BreedingModel breeding;

  const BreedingPrimaryActionButton({super.key, required this.breeding});

  @override
  Widget build(BuildContext context) {
    switch (breeding.status.toLowerCase()) {
      case 'delivered':
        return FloatingActionButton.extended(
          heroTag: 'record_weaning',
          onPressed: () => _recordWeaning(context),
          icon: const Icon(Icons.pets),
          label: const Text('Record Weaning'),
        );

      case 'weaned':
        return FloatingActionButton.extended(
          heroTag: 'record_separation',
          onPressed: () => _recordSeparation(context),
          icon: const Icon(Icons.call_split),
          label: const Text('Record Separation'),
        );

      case 'separated':
        return const SizedBox.shrink();

      default:
        return FloatingActionButton.extended(
          heroTag: 'record_birth',
          onPressed: () => _recordBirth(context),
          icon: const Icon(Icons.child_friendly),
          label: const Text('Record Birth'),
        );
    }
  }

  Future<void> _recordBirth(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RecordBirthSheet(breedingId: breeding.breedingId),
    );
  }

  Future<void> _recordWeaning(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RecordWeaningSheet(breedingId: breeding.breedingId),
    );
  }

  Future<void> _recordSeparation(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RecordSeparationSheet(breedingId: breeding.breedingId),
    );
  }
}
