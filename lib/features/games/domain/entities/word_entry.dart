import 'package:equatable/equatable.dart';

class WordEntry extends Equatable {
  final String id;
  final String udmurt;
  final String russian;
  final String category;
  final String emoji;
  final String transcription;

  const WordEntry({
    required this.id,
    required this.udmurt,
    required this.russian,
    required this.category,
    required this.emoji,
    this.transcription = '',
  });

  @override
  List<Object?> get props => [id, udmurt, russian, category, emoji, transcription];
}
