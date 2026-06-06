import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:t2_mobile_application/features/lessons/data/datasources/lessons_remote_data_source.dart';
import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';
import 'package:t2_mobile_application/features/lessons/domain/repositories/lessons_repository.dart';

@LazySingleton(as: LessonsRepository)
final class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsLocalDataSource _dataSource;
  final LessonsRemoteDataSource _remoteDataSource;

  LessonsRepositoryImpl(this._dataSource, this._remoteDataSource);

  @override
  Future<LessonProgress> getProgress() async {
    final localProgress = await _dataSource.getProgress();
    final remoteWords = await _remoteDataSource.getViewedWords();

    // Sync missing to local
    for (var word in remoteWords) {
      if (!localProgress.viewedWordIds.contains(word)) {
        await _dataSource.markViewed(word);
      }
    }

    // Sync missing to remote
    for (var word in localProgress.viewedWordIds) {
      if (!remoteWords.contains(word)) {
        await _remoteDataSource.markViewed(word);
      }
    }

    return await _dataSource.getProgress();
  }

  @override
  Future<void> markViewed(String wordId) async {
    await _dataSource.markViewed(wordId);
    await _remoteDataSource.markViewed(wordId);
  }
}
