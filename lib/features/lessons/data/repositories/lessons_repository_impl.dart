import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';
import 'package:t2_mobile_application/features/lessons/domain/repositories/lessons_repository.dart';

@LazySingleton(as: LessonsRepository)
final class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsLocalDataSource _dataSource;

  LessonsRepositoryImpl(this._dataSource);

  @override
  Future<LessonProgress> getProgress() => _dataSource.getProgress();

  @override
  Future<void> markViewed(String wordId) => _dataSource.markViewed(wordId);
}
