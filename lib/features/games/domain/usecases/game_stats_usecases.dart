import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/repositories/games_repository.dart';

class SaveResultParams {
  final String gameKey;
  final bool isCorrect;
  const SaveResultParams({required this.gameKey, required this.isCorrect});
}

@lazySingleton
final class SaveGameResultUseCase {
  final GamesRepository repository;
  const SaveGameResultUseCase(this.repository);

  Future<void> call(SaveResultParams params) =>
      repository.saveResult(gameKey: params.gameKey, isCorrect: params.isCorrect);
}

@lazySingleton
final class GetGameStatsUseCase {
  final GamesRepository repository;
  const GetGameStatsUseCase(this.repository);

  Future<GameStats> call() => repository.getStats();
}
