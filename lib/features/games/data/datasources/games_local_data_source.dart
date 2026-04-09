import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';

abstract interface class GamesLocalDataSource {
  List<WordEntry> getAllWords();
  Future<GameStats> getStats();
  Future<void> saveResult({required String gameKey, required bool isCorrect});
}
