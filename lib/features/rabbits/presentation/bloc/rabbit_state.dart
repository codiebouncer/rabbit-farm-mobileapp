import 'package:equatable/equatable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_profile.dart';
import '../../data/models/cage_search_model.dart';

enum RabbitListStatus { initial, loading, success, refreshing, failure }

enum RabbitDetailsStatus { initial, loading, success, failure }

enum RabbitSubmissionStatus { idle, submitting, success, failure }

enum RabbitActionStatus { idle, submitting, success, failure }

class RabbitState extends Equatable {
  final RabbitListStatus listStatus;
  final RabbitDetailsStatus detailsStatus;
  final RabbitSubmissionStatus submissionStatus;
  final RabbitActionStatus actionStatus;
  final List<RabbitModel> rabbits;
  final RabbitProfile? profile;
  final List<CageSearchModel> availableCages;
  final String selectedFilter;
  final String searchQuery;
  final int page;
  final int totalCount;
  final bool hasNextPage;
  final bool loadingMore;
  final String? listMessage;
  final String? detailsMessage;
  final String? submissionMessage;
  final String? actionMessage;
  final String? createdRabbitId;
  final AppFailureKind? listFailureKind;
  final AppFailureKind? detailsFailureKind;
  final Map<String, List<String>> fieldErrors;

  const RabbitState({
    this.listStatus = RabbitListStatus.initial,
    this.detailsStatus = RabbitDetailsStatus.initial,
    this.submissionStatus = RabbitSubmissionStatus.idle,
    this.actionStatus = RabbitActionStatus.idle,
    this.rabbits = const [],
    this.profile,
    this.availableCages = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.page = 0,
    this.totalCount = 0,
    this.hasNextPage = false,
    this.loadingMore = false,
    this.listMessage,
    this.detailsMessage,
    this.submissionMessage,
    this.actionMessage,
    this.createdRabbitId,
    this.listFailureKind,
    this.detailsFailureKind,
    this.fieldErrors = const {},
  });

  RabbitState copyWith({
    RabbitListStatus? listStatus,
    RabbitDetailsStatus? detailsStatus,
    RabbitSubmissionStatus? submissionStatus,
    RabbitActionStatus? actionStatus,
    List<RabbitModel>? rabbits,
    RabbitProfile? profile,
    List<CageSearchModel>? availableCages,
    String? selectedFilter,
    String? searchQuery,
    int? page,
    int? totalCount,
    bool? hasNextPage,
    bool? loadingMore,
    String? listMessage,
    String? detailsMessage,
    String? submissionMessage,
    String? actionMessage,
    String? createdRabbitId,
    AppFailureKind? listFailureKind,
    AppFailureKind? detailsFailureKind,
    Map<String, List<String>>? fieldErrors,
    bool clearListMessage = false,
    bool clearDetailsMessage = false,
    bool clearSubmission = false,
    bool clearAction = false,
  }) {
    return RabbitState(
      listStatus: listStatus ?? this.listStatus,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      submissionStatus:
          submissionStatus ??
          (clearSubmission
              ? RabbitSubmissionStatus.idle
              : this.submissionStatus),
      actionStatus:
          actionStatus ??
          (clearAction ? RabbitActionStatus.idle : this.actionStatus),
      rabbits: rabbits ?? this.rabbits,
      profile: profile ?? this.profile,
      availableCages: availableCages ?? this.availableCages,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      loadingMore: loadingMore ?? this.loadingMore,
      listMessage: clearListMessage ? null : listMessage ?? this.listMessage,
      detailsMessage: clearDetailsMessage
          ? null
          : detailsMessage ?? this.detailsMessage,
      submissionMessage: clearSubmission
          ? null
          : submissionMessage ?? this.submissionMessage,
      actionMessage: clearAction ? null : actionMessage ?? this.actionMessage,
      createdRabbitId: clearSubmission
          ? null
          : createdRabbitId ?? this.createdRabbitId,
      listFailureKind: listFailureKind ?? this.listFailureKind,
      detailsFailureKind: detailsFailureKind ?? this.detailsFailureKind,
      fieldErrors: clearSubmission ? const {} : fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [
    listStatus,
    detailsStatus,
    submissionStatus,
    actionStatus,
    rabbits,
    profile,
    availableCages,
    selectedFilter,
    searchQuery,
    page,
    totalCount,
    hasNextPage,
    loadingMore,
    listMessage,
    detailsMessage,
    submissionMessage,
    actionMessage,
    createdRabbitId,
    listFailureKind,
    detailsFailureKind,
    fieldErrors,
  ];
}
