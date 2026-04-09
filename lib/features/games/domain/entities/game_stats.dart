import 'package:equatable/equatable.dart';

class GameStats extends Equatable {
  final int totalAnswered;
  final int totalCorrect;
  final Map<String, int> correctPerGame; // 'translate', 'compile', 'truefalse'
  final Map<String, int> totalPerGame;

  const GameStats({
    this.totalAnswered = 0,
    this.totalCorrect = 0,
    this.correctPerGame = const {},
    this.totalPerGame = const {},
  });

  double get accuracy =>
      totalAnswered == 0 ? 0 : totalCorrect / totalAnswered;

  GameStats copyWithResult({required String gameKey, required bool isCorrect}) {
    final newCorrectPerGame = Map<String, int>.from(correctPerGame);
    final newTotalPerGame = Map<String, int>.from(totalPerGame);
    newTotalPerGame[gameKey] = (newTotalPerGame[gameKey] ?? 0) + 1;
    if (isCorrect) {
      newCorrectPerGame[gameKey] = (newCorrectPerGame[gameKey] ?? 0) + 1;
    }
    return GameStats(
      totalAnswered: totalAnswered + 1,
      totalCorrect: totalCorrect + (isCorrect ? 1 : 0),
      correctPerGame: newCorrectPerGame,
      totalPerGame: newTotalPerGame,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalAnswered': totalAnswered,
        'totalCorrect': totalCorrect,
        'correctPerGame': correctPerGame,
        'totalPerGame': totalPerGame,
      };

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        totalAnswered: (json['totalAnswered'] as int?) ?? 0,
        totalCorrect: (json['totalCorrect'] as int?) ?? 0,
        correctPerGame: Map<String, int>.from(json['correctPerGame'] ?? {}),
        totalPerGame: Map<String, int>.from(json['totalPerGame'] ?? {}),
      );

  @override
  List<Object?> get props =>
      [totalAnswered, totalCorrect, correctPerGame, totalPerGame];
}
