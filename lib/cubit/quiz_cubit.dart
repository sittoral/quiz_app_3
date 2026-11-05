import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/history_model.dart';
import '../repositories/quiz_repository.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  static const int timeLimit = 15;

  final QuizRepository repository;
  final int amount;
  final int? category;
  final String categoryName;
  final String? difficulty;

  Timer? _timer;
  Timer? _nextTimer;

  QuizCubit({
    required this.repository,
    required this.amount,
    required this.categoryName,
    this.category,
    this.difficulty,
  }) : super(const QuizState());

  Future<void> load() async {
    try {
      final questions = await repository.getQuestions(
        amount: amount,
        category: category,
        difficulty: difficulty,
      );
      if (questions.isEmpty) {
        emit(state.copyWith(status: QuizStatus.error));
        return;
      }
      emit(state.copyWith(status: QuizStatus.loaded, questions: questions));
      _startTimer();
    } catch (_) {
      emit(state.copyWith(status: QuizStatus.error));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(secondsLeft: timeLimit, answered: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsLeft <= 1) {
        emit(state.copyWith(secondsLeft: 0));
        _reveal(false); // время вышло
      } else {
        emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
      }
    });
  }

  void selectAnswer(String answer) {
    if (state.answered) return;
    final isCorrect = state.questions[state.index].correctAnswer == answer;
    _reveal(isCorrect);
  }

  // показать цвета и через 2 сек перейти дальше
  void _reveal(bool isCorrect) {
    _timer?.cancel();
    emit(state.copyWith(
      answered: true,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
    ));
    _nextTimer = Timer(const Duration(seconds: 2), _next);
  }

  void _next() {
    if (state.index + 1 >= state.questions.length) {
      emit(state.copyWith(
        status: QuizStatus.finished,
        result: HistoryModel(
          category: categoryName,
          difficulty: difficulty == null
              ? 'All'
              : difficulty![0].toUpperCase() + difficulty!.substring(1),
          correct: state.correctCount,
          total: state.questions.length,
          date: DateTime.now(),
        ),
      ));
      return;
    }
    emit(state.copyWith(index: state.index + 1));
    _startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _nextTimer?.cancel();
    return super.close();
  }
}