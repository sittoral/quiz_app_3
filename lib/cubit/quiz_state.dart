import '../models/history_model.dart';
import '../models/quiz_model.dart';

enum QuizStatus { loading, loaded, error, finished }

class QuizState {
  final QuizStatus status;
  final List<QuizModel> questions;
  final int index;
  final int secondsLeft;
  final bool answered;
  final int correctCount;
  final HistoryModel? result;

  const QuizState({
    this.status = QuizStatus.loading,
    this.questions = const [],
    this.index = 0,
    this.secondsLeft = 15,
    this.answered = false,
    this.correctCount = 0,
    this.result,
  });

  QuizState copyWith({
    QuizStatus? status,
    List<QuizModel>? questions,
    int? index,
    int? secondsLeft,
    bool? answered,
    int? correctCount,
    HistoryModel? result,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      index: index ?? this.index,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      answered: answered ?? this.answered,
      correctCount: correctCount ?? this.correctCount,
      result: result ?? this.result,
    );
  }
}