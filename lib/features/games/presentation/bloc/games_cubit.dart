import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/games/domain/usecases/game_stats_usecases.dart';
import 'package:t2_mobile_application/features/games/domain/usecases/get_words_usecase.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';

const _questionsPerRound = 10;

@lazySingleton
final class GamesCubit extends Cubit<GamesState> {
  final GetWordsUseCase _getWords;
  final SaveGameResultUseCase _saveResult;
  final GetGameStatsUseCase _getStats;
  final _rng = Random();

  GamesCubit(this._getWords, this._saveResult, this._getStats)
    : super(const GamesLoading());

  Future<void> loadStats() async {
    emit(const GamesLoading());
    final stats = await _getStats.call();
    emit(GamesInitial(stats: stats));
  }

  // ── start a game mode ─────────────────────────────────────────────────────
  Future<void> startGame(String gameKey) async {
    final allWords = await _getWords(const NoParams());
    final words = gameKey == 'compile'
        ? allWords.where((w) => w.udmurt.length <= 12).toList()
        : allWords;

    final shuffled = List<WordEntry>.from(words)..shuffle(_rng);
    final questions = shuffled.take(_questionsPerRound).toList();
    _emitQuestion(gameKey: gameKey, questions: questions, index: 0, score: 0);
  }

  void _emitQuestion({
    required String gameKey,
    required List<WordEntry> questions,
    required int index,
    required int score,
  }) {
    if (index >= questions.length) {
      emit(
        QuizComplete(score: score, total: questions.length, gameKey: gameKey),
      );
      return;
    }
    final all = questions; // reuse for distractors from same batch
    final question = questions[index];
    final options = _buildOptions(gameKey, question, all);

    emit(
      QuizInProgress(
        gameKey: gameKey,
        question: question,
        options: options,
        scrambledLetters: [], // unused for translate/truefalse
        currentIndex: index,
        totalQuestions: questions.length,
        score: score,
      ),
    );

    // Store questions list for advancing later
    _currentQuestions = questions;
  }

  // ── answer handling ───────────────────────────────────────────────────────
  Future<void> answerQuestion(String answer) async {
    final state = this.state;
    if (state is! QuizInProgress) return;

    final isCorrect = answer == state.question.russian;
    await _saveResult(
      SaveResultParams(gameKey: state.gameKey, isCorrect: isCorrect),
    );
    emit(
      QuizAnswered(
        isCorrect: isCorrect,
        previous: state,
        correctAnswer: state.question.russian,
      ),
    );
  }

  Future<void> answerTrueFalse(bool userSaysTrue) async {
    final state = this.state;
    if (state is! QuizInProgress) return;
    // options[0] = shown udmurt word, options[1] = 'true'/'false' flag
    final shownWord = state.options[0];
    final isActuallyCorrect = state.options[1] == 'true';
    final isCorrect = userSaysTrue == isActuallyCorrect;
    await _saveResult(
      SaveResultParams(gameKey: state.gameKey, isCorrect: isCorrect),
    );
    emit(
      QuizAnswered(
        isCorrect: isCorrect,
        previous: state,
        correctAnswer: isActuallyCorrect
            ? '✓ «$shownWord» — верно'
            : '✗ Правильно: «${state.question.udmurt}»',
      ),
    );
  }

  Future<void> answerCompile(String assembledWord) async {
    final state = this.state;
    if (state is! QuizInProgress) return;
    final isCorrect = assembledWord.trim() == state.question.udmurt.trim();
    await _saveResult(
      SaveResultParams(gameKey: state.gameKey, isCorrect: isCorrect),
    );
    emit(
      QuizAnswered(
        isCorrect: isCorrect,
        previous: state,
        correctAnswer: state.question.udmurt,
      ),
    );
  }

  Future<void> nextQuestion() async {
    final state = this.state;
    if (state is! QuizAnswered) return;
    final prev = state.previous;
    final nextIndex = prev.currentIndex + 1;
    final newScore = prev.score + (state.isCorrect ? 1 : 0);
    _emitQuestion(
      gameKey: prev.gameKey,
      questions: _currentQuestions,
      index: nextIndex,
      score: newScore,
    );
  }

  // ── helpers ───────────────────────────────────────────────────────────────
  List<WordEntry> _currentQuestions = [];

  List<String> _buildOptions(
    String gameKey,
    WordEntry question,
    List<WordEntry> pool,
  ) {
    if (gameKey == 'truefalse') {
      // 50/50: show correct or random wrong udmurt word
      final showCorrect = _rng.nextBool();
      if (showCorrect) {
        return [question.udmurt, 'true'];
      } else {
        final others = pool.where((w) => w.id != question.id).toList()
          ..shuffle(_rng);
        return [others.first.udmurt, 'false'];
      }
    }

    // translate: 1 correct + 3 wrong Russian translations
    final distractors = pool.where((w) => w.id != question.id).toList()
      ..shuffle(_rng);
    final options = [
      question.russian,
      ...distractors.take(3).map((e) => e.russian),
    ]..shuffle(_rng);
    return options;
  }
}
