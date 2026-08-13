class BreedSearchModel {
  final int breedId;
  final String breedName;

  const BreedSearchModel({required this.breedId, required this.breedName});

  factory BreedSearchModel.fromJson(Map<String, dynamic> json) {
    return BreedSearchModel(
      breedId: json['breedId'],
      breedName: json['breedName'],
    );
  }
}
