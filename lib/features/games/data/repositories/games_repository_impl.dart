import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/games/data/datasources/games_local_data_source.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/games/domain/repositories/games_repository.dart';

@LazySingleton(as: GamesRepository)
final class GamesRepositoryImpl implements GamesRepository {
  final GamesLocalDataSource dataSource;
  const GamesRepositoryImpl(this.dataSource);

  @override
  List<WordEntry> getAllWords() => dataSource.getAllWords();

  @override
  Future<GameStats> getStats() => dataSource.getStats();

  @override
  Future<void> saveResult({required String gameKey, required bool isCorrect}) =>
      dataSource.saveResult(gameKey: gameKey, isCorrect: isCorrect);
}
