import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';

abstract class LessonsRepository {
  Future<LessonProgress> getProgress();
  Future<void> markViewed(String wordId);
}
