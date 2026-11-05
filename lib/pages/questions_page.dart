import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../repositories/quiz_repository.dart';
import 'result_page.dart';

class QuestionsPage extends StatefulWidget {
  final int amount;
  final int? category;
  final String? difficulty;

  const QuestionsPage({
    super.key,
    required this.amount,
    this.category,
    this.difficulty,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  static const int _timeLimit = 15;

  final _repository = QuizRepository();
  List<QuizModel> _questions = [];
  bool _loading = true;
  bool _error = false;

  int _index = 0;
  bool _answered = false;
  int _secondsLeft = _timeLimit;

  Timer? _timer;
  Timer? _nextTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nextTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final questions = await _repository.getQuestions(
        amount: widget.amount,
        category: widget.category,
        difficulty: widget.difficulty,
      );
      if (!mounted) return;
      if (questions.isEmpty) {
        setState(() {
          _loading = false;
          _error = true;
        });
        return;
      }
      setState(() {
        _questions = questions;
        _loading = false;
      });
      _startTimer();
    } catch (e) {
      debugPrint('LOAD ERROR: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _timeLimit;
      _answered = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        _reveal();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // показать правильный/неправильные ответы и через 2 сек перейти дальше
  void _reveal() {
    _timer?.cancel();
    setState(() => _answered = true);
    _nextTimer = Timer(const Duration(seconds: 2), _next);
  }

  void _next() {
    if (!mounted) return;
    if (_index + 1 >= _questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultPage()),
      );
      return;
    }
    setState(() => _index++);
    _startTimer();
  }

  void _onAnswerTap() {
    if (_answered) return;
    _reveal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _buildBody());
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error) return const Center(child: Text('Could not load questions'));

    final quiz = _questions[_index];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_index + 1}/${_questions.length}'),
              Text('$_secondsLeft s'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: (_index + 1) / _questions.length),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  quiz.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 32),
                for (final answer in quiz.answers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: _answered
                            ? ElevatedButton.styleFrom(
                                backgroundColor: answer == quiz.correctAnswer
                                    ? Colors.green
                                    : Colors.red,
                                foregroundColor: Colors.white,
                              )
                            : null,
                        onPressed: _onAnswerTap,
                        child: Text(answer),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
