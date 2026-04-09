import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/games/domain/usecases/get_words_usecase.dart';
import 'package:t2_mobile_application/features/lessons/domain/usecases/lesson_progress_usecases.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_state.dart';

@lazySingleton
class LessonsCubit extends Cubit<LessonsState> {
  final GetWordsUseCase _getWords;
  final GetLessonProgressUseCase _getProgress;
  final MarkWordViewedUseCase _markViewed;

  LessonsCubit(this._getWords, this._getProgress, this._markViewed)
      : super(const LessonsLoading());

  Future<void> loadData() async {
    emit(const LessonsLoading());
    final words = await _getWords(const NoParams());
    final progress = await _getProgress(const NoParams());

    final grouped = <String, List<WordEntry>>{};
    for (final w in words) {
      if (!grouped.containsKey(w.category)) {
        grouped[w.category] = [];
      }
      grouped[w.category]!.add(w);
    }

    emit(LessonsLoaded(groupedWords: grouped, progress: progress));
  }

  Future<void> markWordViewed(String wordId) async {
    final state = this.state;
    if (state is LessonsLoaded) {
      final isAlreadyViewed = state.progress.viewedWordIds.contains(wordId);
      if (!isAlreadyViewed) {
        await _markViewed(MarkWordViewedParams(wordId));
        final newProgress = state.progress.copyWithViewed(wordId);
        emit(LessonsLoaded(groupedWords: state.groupedWords, progress: newProgress));
      }
    }
  }
}
