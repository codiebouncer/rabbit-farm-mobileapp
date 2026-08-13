import 'package:equatable/equatable.dart';

import '../../data/models/create_breeding_request.dart';
import '../../data/models/update_breeding_request.dart';
import '../../data/models/record_birth_request.dart';
import '../../data/models/record_weaning_request.dart';
import '../../data/models/record_separation_request.dart';

abstract class BreedingEvent extends Equatable {
  const BreedingEvent();

  @override
  List<Object?> get props => [];
}

class LoadBreedings extends BreedingEvent {}

class RefreshBreedings extends BreedingEvent {}

class LoadBreedingDetails extends BreedingEvent {
  final String breedingId;

  const LoadBreedingDetails(this.breedingId);

  @override
  List<Object?> get props => [breedingId];
}

class FilterBreedings extends BreedingEvent {
  final String filter;

  const FilterBreedings(this.filter);

  @override
  List<Object?> get props => [filter];
}

class CreateBreeding extends BreedingEvent {
  final CreateBreedingRequest request;

  const CreateBreeding(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateBreeding extends BreedingEvent {
  final String breedingId;
  final UpdateBreedingRequest request;

  const UpdateBreeding(this.breedingId, this.request);

  @override
  List<Object?> get props => [breedingId, request];
}

class DeleteBreeding extends BreedingEvent {
  final String breedingId;

  const DeleteBreeding(this.breedingId);

  @override
  List<Object?> get props => [breedingId];
}

class RecordBirth extends BreedingEvent {
  final String breedingId;
  final RecordBirthRequest request;

  const RecordBirth(this.breedingId, this.request);

  @override
  List<Object?> get props => [breedingId, request];
}

class RecordWeaning extends BreedingEvent {
  final String breedingId;
  final RecordWeaningRequest request;

  const RecordWeaning(this.breedingId, this.request);

  @override
  List<Object?> get props => [breedingId, request];
}

class RecordSeparation extends BreedingEvent {
  final String breedingId;
  final RecordSeparationRequest request;

  const RecordSeparation(this.breedingId, this.request);

  @override
  List<Object?> get props => [breedingId, request];
}

class SearchBreedings extends BreedingEvent {
  final String query;

  const SearchBreedings(this.query);

  @override
  List<Object?> get props => [query];
}
