import 'rabbit_model.dart';

class PagedRabbits {
  final List<RabbitModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;

  const PagedRabbits({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PagedRabbits.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is! List) throw const FormatException('Invalid rabbit page');
    return PagedRabbits(
      items: rawItems
          .map(
            (item) =>
                RabbitModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}
