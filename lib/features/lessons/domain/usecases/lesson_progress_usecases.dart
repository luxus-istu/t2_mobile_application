import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';
import 'package:t2_mobile_application/features/lessons/domain/repositories/lessons_repository.dart';

@lazySingleton
class GetLessonProgressUseCase implements UseCase<LessonProgress, NoParams> {
  final LessonsRepository _repository;

  GetLessonProgressUseCase(this._repository);

  @override
  Future<LessonProgress> call([NoParams params = const NoParams()]) {
    return _repository.getProgress();
  }
}

class MarkWordViewedParams {
  final String wordId;
  const MarkWordViewedParams(this.wordId);
}

@lazySingleton
class MarkWordViewedUseCase implements UseCase<void, MarkWordViewedParams> {
  final LessonsRepository _repository;

  MarkWordViewedUseCase(this._repository);

  @override
  Future<void> call(MarkWordViewedParams params) {
    return _repository.markViewed(params.wordId);
  }
}
