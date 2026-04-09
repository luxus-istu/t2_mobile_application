import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:t2_mobile_application/features/lessons/domain/entities/lesson_progress.dart';

@LazySingleton(as: LessonsLocalDataSource)
final class LessonsLocalDataSourceImpl implements LessonsLocalDataSource {
  final Box<String> progressBox;
  final FlutterSecureStorage storage;

  const LessonsLocalDataSourceImpl(
    @Named('lesson_progress_box') this.progressBox,
    this.storage,
  );

  Future<String?> _userKey() => storage.read(key: 'active_user_phone');

  @override
  Future<LessonProgress> getProgress() async {
    final key = await _userKey();
    if (key == null) return const LessonProgress();
    final raw = progressBox.get('progress_$key');
    if (raw == null) return const LessonProgress();
    try {
      return LessonProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const LessonProgress();
    }
  }

  @override
  Future<void> markViewed(String wordId) async {
    final key = await _userKey();
    if (key == null) return;
    final current = await getProgress();
    final updated = current.copyWithViewed(wordId);
    await progressBox.put('progress_$key', jsonEncode(updated.toJson()));
  }
}
