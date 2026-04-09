import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/games/data/datasources/games_local_data_source.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';

@LazySingleton(as: GamesLocalDataSource)
final class GamesLocalDataSourceImpl implements GamesLocalDataSource {
  final Box<String> statsBox;
  final FlutterSecureStorage storage;
  static const _sessionKey = 'active_user_phone';

  const GamesLocalDataSourceImpl(
    @Named('game_stats_box') this.statsBox,
    this.storage,
  );

  // ── word database ─────────────────────────────────────────────────────────
  static const List<WordEntry> _words = [
    // Greetings
    WordEntry(id: 'g1', udmurt: 'ӟечбуресь', transcription: '[ӟечбуресь]', russian: 'здравствуйте', category: 'greetings', emoji: '👋'),
    WordEntry(id: 'g2', udmurt: 'чырткем', transcription: '[чырткем]', russian: 'привет', category: 'greetings', emoji: '🙋'),
    WordEntry(id: 'g3', udmurt: 'тау', transcription: '[тау]', russian: 'спасибо', category: 'greetings', emoji: '🙏'),
    WordEntry(id: 'g4', udmurt: 'ӟеч лу', transcription: '[ӟеч лу]', russian: 'до свидания', category: 'greetings', emoji: '👋'),
    WordEntry(id: 'g5', udmurt: 'бур ӵукна', transcription: '[бур ӵукна]', russian: 'доброе утро', category: 'greetings', emoji: '🌅'),
    WordEntry(id: 'g6', udmurt: 'салам', transcription: '[салам]', russian: 'привет', category: 'greetings', emoji: '😊'),
    // Numbers
    WordEntry(id: 'n1', udmurt: 'одӥг', transcription: '[одӥг]', russian: 'один', category: 'numbers', emoji: '1️⃣'),
    WordEntry(id: 'n2', udmurt: 'кык', transcription: '[кык]', russian: 'два', category: 'numbers', emoji: '2️⃣'),
    WordEntry(id: 'n3', udmurt: 'куинь', transcription: '[куинь]', russian: 'три', category: 'numbers', emoji: '3️⃣'),
    WordEntry(id: 'n4', udmurt: 'ньыль', transcription: '[ньыль]', russian: 'четыре', category: 'numbers', emoji: '4️⃣'),
    WordEntry(id: 'n5', udmurt: 'вить', transcription: '[вить]', russian: 'пять', category: 'numbers', emoji: '5️⃣'),
    WordEntry(id: 'n6', udmurt: 'куать', transcription: '[куать]', russian: 'шесть', category: 'numbers', emoji: '6️⃣'),
    WordEntry(id: 'n7', udmurt: 'сизьым', transcription: '[сизьым]', russian: 'семь', category: 'numbers', emoji: '7️⃣'),
    WordEntry(id: 'n8', udmurt: 'тямыс', transcription: '[тямыс]', russian: 'восемь', category: 'numbers', emoji: '8️⃣'),
    WordEntry(id: 'n9', udmurt: 'укмыс', transcription: '[укмыс]', russian: 'девять', category: 'numbers', emoji: '9️⃣'),
    WordEntry(id: 'n10', udmurt: 'дас', transcription: '[дас]', russian: 'десять', category: 'numbers', emoji: '🔟'),
    // Wild animals
    WordEntry(id: 'wa1', udmurt: 'гондыр', transcription: '[гондыр]', russian: 'медведь', category: 'wild_animals', emoji: '🐻'),
    WordEntry(id: 'wa2', udmurt: 'кион', transcription: '[кион]', russian: 'волк', category: 'wild_animals', emoji: '🐺'),
    WordEntry(id: 'wa3', udmurt: 'койык', transcription: '[койык]', russian: 'лось', category: 'wild_animals', emoji: '🦌'),
    WordEntry(id: 'wa4', udmurt: 'ӟичы', transcription: '[ӟичы]', russian: 'лисица', category: 'wild_animals', emoji: '🦊'),
    WordEntry(id: 'wa5', udmurt: 'лудкеч', transcription: '[лудкеч]', russian: 'заяц', category: 'wild_animals', emoji: '🐇'),
    WordEntry(id: 'wa6', udmurt: 'коньы', transcription: '[коньы]', russian: 'белка', category: 'wild_animals', emoji: '🐿️'),
    WordEntry(id: 'wa7', udmurt: 'ӵушъял', transcription: '[ӵушъял]', russian: 'ёж', category: 'wild_animals', emoji: '🦔'),
    WordEntry(id: 'wa8', udmurt: 'кырпарсь', transcription: '[кырпарсь]', russian: 'кабан', category: 'wild_animals', emoji: '🐗'),
    // Domestic animals
    WordEntry(id: 'da1', udmurt: 'скал', transcription: '[скал]', russian: 'корова', category: 'domestic_animals', emoji: '🐄'),
    WordEntry(id: 'da2', udmurt: 'вал', transcription: '[вал]', russian: 'лошадь', category: 'domestic_animals', emoji: '🐴'),
    WordEntry(id: 'da3', udmurt: 'ыж', transcription: '[ыж]', russian: 'овца', category: 'domestic_animals', emoji: '🐑'),
    WordEntry(id: 'da4', udmurt: 'атас', transcription: '[атас]', russian: 'петух', category: 'domestic_animals', emoji: '🐓'),
    WordEntry(id: 'da5', udmurt: 'парсь', transcription: '[парсь]', russian: 'свинья', category: 'domestic_animals', emoji: '🐷'),
    WordEntry(id: 'da6', udmurt: 'кеч', transcription: '[кеч]', russian: 'коза', category: 'domestic_animals', emoji: '🐐'),
    WordEntry(id: 'da7', udmurt: 'пуны', transcription: '[пуны]', russian: 'собака', category: 'domestic_animals', emoji: '🐕'),
    WordEntry(id: 'da8', udmurt: 'курег', transcription: '[курег]', russian: 'курица', category: 'domestic_animals', emoji: '🐔'),
    // Food
    WordEntry(id: 'f1', udmurt: 'нянь', transcription: '[нянь]', russian: 'хлеб', category: 'food', emoji: '🍞'),
    WordEntry(id: 'f2', udmurt: 'йӧл', transcription: '[йӧл]', russian: 'молоко', category: 'food', emoji: '🥛'),
    WordEntry(id: 'f3', udmurt: 'ӝук', transcription: '[ӝук]', russian: 'каша', category: 'food', emoji: '🥣'),
    WordEntry(id: 'f4', udmurt: 'пельнянь', transcription: '[пельнянь]', russian: 'пельмени', category: 'food', emoji: '🥟'),
    WordEntry(id: 'f5', udmurt: 'шыд', transcription: '[шыд]', russian: 'суп', category: 'food', emoji: '🍲'),
    WordEntry(id: 'f6', udmurt: 'кукей', transcription: '[кукей]', russian: 'яйцо', category: 'food', emoji: '🥚'),
    WordEntry(id: 'f7', udmurt: 'сüль', transcription: '[сüль]', russian: 'мясо', category: 'food', emoji: '🥩'),
    WordEntry(id: 'f8', udmurt: 'вöй', transcription: '[вöй]', russian: 'масло', category: 'food', emoji: '🧈'),
    WordEntry(id: 'f9', udmurt: 'табань', transcription: '[табань]', russian: 'блин', category: 'food', emoji: '🥞'),
    // Family
    WordEntry(id: 'fm1', udmurt: 'анай', transcription: '[анай]', russian: 'мама', category: 'family', emoji: '👩'),
    WordEntry(id: 'fm2', udmurt: 'атай', transcription: '[атай]', russian: 'папа', category: 'family', emoji: '👨'),
    WordEntry(id: 'fm3', udmurt: 'апай', transcription: '[апай]', russian: 'сестра', category: 'family', emoji: '👧'),
    WordEntry(id: 'fm4', udmurt: 'агай', transcription: '[агай]', russian: 'брат', category: 'family', emoji: '👦'),
    WordEntry(id: 'fm5', udmurt: 'песянай', transcription: '[песянай]', russian: 'бабушка', category: 'family', emoji: '👵'),
    WordEntry(id: 'fm6', udmurt: 'песятай', transcription: '[песятай]', russian: 'дедушка', category: 'family', emoji: '👴'),
    WordEntry(id: 'fm7', udmurt: 'нылы', transcription: '[нылы]', russian: 'дочь', category: 'family', emoji: '👧'),
    WordEntry(id: 'fm8', udmurt: 'пие', transcription: '[пие]', russian: 'сын', category: 'family', emoji: '👦'),
    WordEntry(id: 'fm9', udmurt: 'кышно', transcription: '[кышно]', russian: 'жена', category: 'family', emoji: '👰'),
    // Vegetables
    WordEntry(id: 'v1', udmurt: 'сугон', transcription: '[сугон]', russian: 'лук', category: 'vegetables', emoji: '🧅'),
    WordEntry(id: 'v2', udmurt: 'кубиста', transcription: '[кубиста]', russian: 'капуста', category: 'vegetables', emoji: '🥬'),
    WordEntry(id: 'v3', udmurt: 'гордкушман', transcription: '[гордкушман]', russian: 'свёкла', category: 'vegetables', emoji: '🫚'),
    WordEntry(id: 'v4', udmurt: 'кешыр', transcription: '[кешыр]', russian: 'морковь', category: 'vegetables', emoji: '🥕'),
    WordEntry(id: 'v5', udmurt: 'кияр', transcription: '[кияр]', russian: 'огурец', category: 'vegetables', emoji: '🥒'),
    // Colors
    WordEntry(id: 'c1', udmurt: 'тӧдьы', transcription: '[тӧдьы]', russian: 'белый', category: 'colors', emoji: '⬜'),
    WordEntry(id: 'c2', udmurt: 'сьӧд', transcription: '[сьӧд]', russian: 'чёрный', category: 'colors', emoji: '⬛'),
    WordEntry(id: 'c3', udmurt: 'лыз', transcription: '[лыз]', russian: 'синий', category: 'colors', emoji: '🟦'),
    WordEntry(id: 'c4', udmurt: 'ӵуж', transcription: '[ӵуж]', russian: 'жёлтый', category: 'colors', emoji: '🟨'),
    WordEntry(id: 'c5', udmurt: 'вож', transcription: '[вож]', russian: 'зелёный', category: 'colors', emoji: '🟩'),
    WordEntry(id: 'c6', udmurt: 'горд', transcription: '[горд]', russian: 'красный', category: 'colors', emoji: '🟥'),
    WordEntry(id: 'c7', udmurt: 'льӧль', transcription: '[льӧль]', russian: 'розовый', category: 'colors', emoji: '🩷'),
    // Berries
    WordEntry(id: 'b1', udmurt: 'узы', transcription: '[узы]', russian: 'земляника', category: 'berries', emoji: '🍓'),
    WordEntry(id: 'b2', udmurt: 'боры', transcription: '[боры]', russian: 'клубника', category: 'berries', emoji: '🍓'),
    WordEntry(id: 'b3', udmurt: 'нюрмульы', transcription: '[нюрмульы]', russian: 'клюква', category: 'berries', emoji: '🫐'),
    WordEntry(id: 'b4', udmurt: 'лызмульы', transcription: '[лызмульы]', russian: 'голубика', category: 'berries', emoji: '🫐'),
    // Phrases
    WordEntry(id: 'p1', udmurt: 'Мон шумпотӥсько', transcription: '[Мон шумпотӥсько]', russian: 'Я рада(рад)', category: 'phrases', emoji: '😊'),
    WordEntry(id: 'p2', udmurt: 'Мон кышкасько', transcription: '[Мон кышкасько]', russian: 'Мне страшно', category: 'phrases', emoji: '😨'),
    WordEntry(id: 'p3', udmurt: 'Мон тонэ яратӥсько', transcription: '[Мон тонэ яратӥсько]', russian: 'Я тебя люблю', category: 'phrases', emoji: '❤️'),
    WordEntry(id: 'p4', udmurt: 'Мон уг валаськы', transcription: '[Мон уг валаськы]', russian: 'Я не понимаю', category: 'phrases', emoji: '🤷'),
    WordEntry(id: 'p5', udmurt: 'Мынам воже потэ', transcription: '[Мынам воже потэ]', russian: 'Я злюсь', category: 'phrases', emoji: '😠'),
  ];

  @override
  List<WordEntry> getAllWords() => _words;

  // ── Hive stats ────────────────────────────────────────────────────────────
  Future<String?> _userKey() => storage.read(key: _sessionKey);

  @override
  Future<GameStats> getStats() async {
    final key = await _userKey();
    if (key == null) return const GameStats();
    final raw = statsBox.get('stats_$key');
    if (raw == null) return const GameStats();
    try {
      return GameStats.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const GameStats();
    }
  }

  @override
  Future<void> saveResult({
    required String gameKey,
    required bool isCorrect,
  }) async {
    final key = await _userKey();
    if (key == null) return;
    final current = await getStats();
    final updated = current.copyWithResult(gameKey: gameKey, isCorrect: isCorrect);
    await statsBox.put('stats_$key', jsonEncode(updated.toJson()));
  }
}
