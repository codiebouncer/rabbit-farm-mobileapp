import 'rabbit_details_model.dart';
import 'rabbit_history_models.dart';
import 'rabbit_model.dart';

class RabbitProfile {
  final RabbitDetailsModel rabbit;
  final List<RabbitHealthRecord> healthHistory;
  final List<RabbitBreedingRecord> breedingHistory;
  final List<RabbitModel> offspring;
  final List<RabbitSaleRecord> salesHistory;
  final List<RabbitCageMovementRecord> cageMovements;

  const RabbitProfile({
    required this.rabbit,
    required this.healthHistory,
    required this.breedingHistory,
    required this.offspring,
    required this.salesHistory,
    required this.cageMovements,
  });
}
