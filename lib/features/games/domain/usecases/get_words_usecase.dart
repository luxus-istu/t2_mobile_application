import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/games/domain/repositories/games_repository.dart';

@lazySingleton
final class GetWordsUseCase implements UseCase<List<WordEntry>, NoParams> {
  final GamesRepository repository;
  const GetWordsUseCase(this.repository);

  @override
  Future<List<WordEntry>> call(NoParams params) async =>
      repository.getAllWords();
}
