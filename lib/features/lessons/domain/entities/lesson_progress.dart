import 'package:equatable/equatable.dart';

class LessonProgress extends Equatable {
  final Set<String> viewedWordIds;

  const LessonProgress({this.viewedWordIds = const {}});

  LessonProgress copyWithViewed(String wordId) {
    return LessonProgress(viewedWordIds: {...viewedWordIds, wordId});
  }

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    final list = json['viewedWordIds'] as List<dynamic>? ?? [];
    return LessonProgress(viewedWordIds: list.map((e) => e.toString()).toSet());
  }

  Map<String, dynamic> toJson() => {
    'viewedWordIds': viewedWordIds.toList(),
  };

  @override
  List<Object?> get props => [viewedWordIds];
}
