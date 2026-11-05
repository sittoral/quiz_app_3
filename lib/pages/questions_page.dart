import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import '../repositories/quiz_repository.dart';
import 'result_page.dart';

class QuestionsPage extends StatelessWidget {
  final int amount;
  final int? category;
  final String categoryName;
  final String? difficulty;

  const QuestionsPage({
    super.key,
    required this.amount,
    required this.categoryName,
    this.category,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(
        repository: QuizRepository(),
        amount: amount,
        category: category,
        categoryName: categoryName,
        difficulty: difficulty,
      )..load(),
      child: const _QuestionsView(),
    );
  }
}

class _QuestionsView extends StatelessWidget {
  const _QuestionsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listenWhen: (p, c) =>
          c.status == QuizStatus.finished && p.status != QuizStatus.finished,
      listener: (context, state) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultPage(result: state.result!)),
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state.status == QuizStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == QuizStatus.error) {
              return const Center(child: Text('Could not load questions'));
            }
            if (state.questions.isEmpty) return const SizedBox();

            final quiz = state.questions[state.index];

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${state.index + 1}/${state.questions.length}'),
                      Text('${state.secondsLeft} s'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (state.index + 1) / state.questions.length,
                  ),
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
                                style: state.answered
                                    ? ElevatedButton.styleFrom(
                                        backgroundColor:
                                            answer == quiz.correctAnswer
                                                ? Colors.green
                                                : Colors.red,
                                        foregroundColor: Colors.white,
                                      )
                                    : null,
                                onPressed: () => context
                                    .read<QuizCubit>()
                                    .selectAnswer(answer),
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
          },
        ),
      ),
    );
  }
}