import 'package:equatable/equatable.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();
  @override
  List<Object?> get props => [];
}

class LessonsLoading extends LessonsState {
  const LessonsLoading();
}

class LessonsLoaded extends LessonsState {
  final Map<String, List<WordEntry>> groupedWords;
  final LessonProgress progress;

  const LessonsLoaded({
    required this.groupedWords,
    required this.progress,
  });

  @override
  List<Object?> get props => [groupedWords, progress];
}
