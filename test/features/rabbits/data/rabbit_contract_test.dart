import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/move_rabbit_request.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/paged_rabbits.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_details_model.dart';
import 'package:rabbit_farm_mobileapp/features/rabbits/data/models/rabbit_history_models.dart';

void main() {
  group('rabbit API contracts', () {
    test('parses a paged rabbit response', () {
      final result = PagedRabbits.fromJson({
        'items': [
          {
            'rabbitId': 'B10RB1',
            'gender': 'F',
            'status': 'Active',
            'breed': 'New Zealand White',
            'cage': 'B10',
            'stage': 'Adult',
          },
        ],
        'page': 2,
        'pageSize': 20,
        'totalCount': 45,
        'totalPages': 3,
        'hasNextPage': true,
      });

      expect(result.items.single.rabbitId, 'B10RB1');
      expect(result.page, 2);
      expect(result.totalCount, 45);
      expect(result.hasNextPage, isTrue);
    });

    test('parses expanded rabbit details and nullable farm data', () {
      final rabbit = RabbitDetailsModel.fromJson({
        'rabbitId': 'A04RB7',
        'gender': 'M',
        'status': 'Active',
        'createdAt': '2026-08-12T10:00:00Z',
        'breedId': 4,
        'breedName': 'Californian',
        'cageId': 'A04',
        'colorMarkings': 'White with dark points',
        'notes': 'Calm temperament',
      });

      expect(rabbit.breedId, 4);
      expect(rabbit.colorMarkings, 'White with dark points');
      expect(rabbit.supplierName, isNull);
    });

    test('parses history records and serializes a dated cage move', () {
      final health = RabbitHealthRecord.fromJson({
        'healthRecordId': 9,
        'treatmentDate': '2026-08-11',
        'treatment': 'Routine deworming',
        'cost': 18.5,
        'notes': null,
      });
      final movement = RabbitCageMovementRecord.fromJson({
        'movementId': '5b4139ad-505a-4d4a-a3ab-46b77967e2d4',
        'fromCageId': 'B10',
        'toCageId': 'C02',
        'effectiveDate': '2026-08-12',
        'reason': 'Capacity balancing',
        'notes': 'Moved after morning feeding',
      });
      const request = MoveRabbitRequest(
        cageId: 'C02',
        effectiveDate: '2026-08-12',
        reason: 'Capacity balancing',
        notes: 'Moved after morning feeding',
      );

      expect(health.cost, 18.5);
      expect(movement.fromCageId, 'B10');
      expect(request.toJson()['effectiveDate'], '2026-08-12');
      expect(request.toJson()['reason'], 'Capacity balancing');
    });

    test('rejects malformed required rabbit fields', () {
      expect(
        () => RabbitDetailsModel.fromJson({
          'rabbitId': 'C02RB3',
          'status': 'Active',
          'createdAt': '2026-08-12T10:00:00Z',
        }),
        throwsFormatException,
      );
    });
  });
}
