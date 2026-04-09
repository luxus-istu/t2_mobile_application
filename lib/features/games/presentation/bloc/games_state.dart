import 'package:equatable/equatable.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';

abstract class GamesState extends Equatable {
  const GamesState();
  @override
  List<Object?> get props => [];
}

class GamesInitial extends GamesState {
  final GameStats stats;
  const GamesInitial({this.stats = const GameStats()});
  @override
  List<Object?> get props => [stats];
}

class GamesLoading extends GamesState {
  const GamesLoading();
}

class QuizInProgress extends GamesState {
  final String gameKey;
  final WordEntry question;
  final List<String> options; // Russian translations to pick from
  final List<WordEntry> scrambledLetters; // for compile game
  final int currentIndex;
  final int totalQuestions;
  final int score;
  const QuizInProgress({
    required this.gameKey,
    required this.question,
    required this.options,
    required this.scrambledLetters,
    required this.currentIndex,
    required this.totalQuestions,
    required this.score,
  });
  @override
  List<Object?> get props =>
      [gameKey, question, options, currentIndex, totalQuestions, score];
}

class QuizAnswered extends GamesState {
  final bool isCorrect;
  final QuizInProgress previous;
  final String correctAnswer;
  const QuizAnswered({
    required this.isCorrect,
    required this.previous,
    required this.correctAnswer,
  });
  @override
  List<Object?> get props => [isCorrect, previous, correctAnswer];
}

class QuizComplete extends GamesState {
  final int score;
  final int total;
  final String gameKey;
  const QuizComplete({
    required this.score,
    required this.total,
    required this.gameKey,
  });
  @override
  List<Object?> get props => [score, total, gameKey];
}
