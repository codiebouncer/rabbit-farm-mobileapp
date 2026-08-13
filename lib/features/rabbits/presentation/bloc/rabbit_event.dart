import '../../data/models/create_rabbbit_request.dart';
import '../../data/models/move_rabbit_request.dart';
import '../../data/models/update_rabbit.dart';

sealed class RabbitEvent {}

class LoadRabbits extends RabbitEvent {}

class LoadMoreRabbits extends RabbitEvent {}

class RefreshRabbits extends RabbitEvent {}

class LoadRabbitDetails extends RabbitEvent {
  final String rabbitId;
  LoadRabbitDetails(this.rabbitId);
}

class LoadMoveRabbit extends RabbitEvent {
  final String rabbitId;
  LoadMoveRabbit(this.rabbitId);
}

class SearchRabbits extends RabbitEvent {
  final String query;
  SearchRabbits(this.query);
}

class FilterRabbits extends RabbitEvent {
  final String filter;
  FilterRabbits(this.filter);
}

class MarkRabbitPregnant extends RabbitEvent {
  final String rabbitId;
  MarkRabbitPregnant(this.rabbitId);
}

class MarkRabbitDeceased extends RabbitEvent {
  final String rabbitId;
  MarkRabbitDeceased(this.rabbitId);
}

class MoveRabbitCage extends RabbitEvent {
  final String rabbitId;
  final MoveRabbitRequest request;
  MoveRabbitCage(this.rabbitId, this.request);
}

class MarkRabbitSold extends RabbitEvent {
  final String rabbitId;
  final double amount;
  final String buyerName;
  final String buyerContact;
  MarkRabbitSold(this.rabbitId, this.amount, this.buyerName, this.buyerContact);
}

class UpdateRabbit extends RabbitEvent {
  final String rabbitId;
  final UpdateRabbitRequest request;
  UpdateRabbit(this.rabbitId, this.request);
}

class CreateRabbit extends RabbitEvent {
  final CreateRabbitRequest request;
  CreateRabbit(this.request);
}

class ResetRabbitSubmission extends RabbitEvent {}

class ResetRabbitAction extends RabbitEvent {}
