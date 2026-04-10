import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/domain/entities/word_entry.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_cubit.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_state.dart';
import 'package:t2_mobile_application/core/utils/sound_helper.dart';

import 'package:confetti/confetti.dart';

class LessonsCardsPage extends StatefulWidget {
  final String topic;
  const LessonsCardsPage({super.key, required this.topic});

  @override
  State<LessonsCardsPage> createState() => _LessonsCardsPageState();
}

class _LessonsCardsPageState extends State<LessonsCardsPage> {
  final _pageCtrl = PageController();
  final _confettiCtrl = ConfettiController(
    duration: const Duration(seconds: 5),
  );
  List<WordEntry> _words = [];

  @override
  void initState() {
    super.initState();
    final state = sl<LessonsCubit>().state;
    if (state is LessonsLoaded) {
      _words = state.groupedWords[widget.topic] ?? [];
      if (_words.isNotEmpty) {
        _onCardViewed(0);
      }
    }
  }

  void _onCardViewed(int idx) {
    if (_words.isEmpty) return;
    sl<LessonsCubit>().markWordViewed(_words[idx].id);
    if (idx == _words.length - 1) {
      _confettiCtrl.play();
      SoundHelper.playSound('win.mp3');
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Карточки')),
        body: const Center(child: Text('Нет слов')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ОБУЧЕНИЕ',
          style: Theme.of(
            ctx,
          ).textTheme.displaySmall?.copyWith(fontSize: 22.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocProvider.value(
              value: sl<LessonsCubit>(),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageCtrl,
                      itemCount: _words.length,
                      onPageChanged: (idx) {
                        _onCardViewed(idx);
                      },
                      itemBuilder: (ctx, idx) {
                        final w = _words[idx];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(ctx).colorScheme.surface,
                              borderRadius: BorderRadius.circular(32.r),
                              border: Border.all(
                                color: Theme.of(
                                  ctx,
                                ).colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  w.emoji,
                                  style: TextStyle(fontSize: 90.sp),
                                ),
                                SizedBox(height: 32.h),
                                Text(
                                  w.udmurt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: T2Theme.magenta,
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  w.transcription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(ctx).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 18.sp,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Container(
                                  width: 60.w,
                                  height: 2,
                                  color: Theme.of(ctx).colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  w.russian,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(ctx).colorScheme.onSurface,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_pageCtrl.page! > 0) {
                              _pageCtrl.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 28.w,
                          ),
                        ),
                        BlocBuilder<LessonsCubit, LessonsState>(
                          builder: (ctx, state) {
                            int viewed = 0;
                            if (state is LessonsLoaded) {
                              viewed = _words
                                  .where(
                                    (w) => state.progress.viewedWordIds
                                        .contains(w.id),
                                  )
                                  .length;
                            }
                            return Text(
                              '$viewed / ${_words.length}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            if (_pageCtrl.page! < _words.length - 1) {
                              _pageCtrl.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 28.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiCtrl,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  T2Theme.magenta,
                  Colors.white,
                  Color(0xFF00C853),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
