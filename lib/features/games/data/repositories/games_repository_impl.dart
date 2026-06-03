import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/games/data/datasources/games_local_data_source.dart';
import 'package:t2_mobile_application/features/games/data/datasources/games_remote_data_source.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/games/domain/repositories/games_repository.dart';

@LazySingleton(as: GamesRepository)
final class GamesRepositoryImpl implements GamesRepository {
  final GamesLocalDataSource dataSource;
  final GamesRemoteDataSource remoteDataSource;
  
  const GamesRepositoryImpl(this.dataSource, this.remoteDataSource);

  @override
  List<WordEntry> getAllWords() => dataSource.getAllWords();

  @override
  Future<GameStats> getStats() async {
    final localStats = await dataSource.getStats();
    // final remoteStats = await remoteDataSource.getResults();
    
    // In a real app, merge remoteStats with localStats and sync both ways.
    // For now, return localStats since it contains the logic for GameStats.
    return localStats;
  }

  @override
  Future<void> saveResult({required String gameKey, required bool isCorrect}) async {
      await dataSource.saveResult(gameKey: gameKey, isCorrect: isCorrect);
      await remoteDataSource.saveResult(gameKey: gameKey, isCorrect: isCorrect);
  }
}
