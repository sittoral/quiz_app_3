import 'package:flutter/material.dart';
import 'history_page.dart';
import 'questions_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  static const Map<String, int?> categories = {
    'Any Category': null,
    'General Knowledge': 9,
    'Entertainment: Books': 10,
    'Entertainment: Film': 11,
    'Entertainment: Music': 12,
    'Entertainment: Musicals & Theatres': 13,
    'Entertainment: Television': 14,
    'Entertainment: Video Games': 15,
    'Entertainment: Board Games': 16,
    'Science & Nature': 17,
    'Science: Computers': 18,
    'Science: Mathematics': 19,
    'Mythology': 20,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Politics': 24,
    'Art': 25,
    'Celebrities': 26,
    'Animals': 27,
    'Vehicles': 28,
    'Entertainment: Comics': 29,
    'Science: Gadgets': 30,
    'Entertainment: Japanese Anime & Manga': 31,
    'Entertainment: Cartoon & Animations': 32,
  };

  static const Map<String, String?> difficulties = {
    'Any Difficulty': null,
    'Easy': 'easy',
    'Medium': 'medium',
    'Hard': 'hard',
  };

  double _amount = 10;
  String _category = 'Any Category';
  String _difficulty = 'Any Difficulty';

  void _start() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionsPage(
          amount: _amount.round(),
          category: categories[_category],
          categoryName: _category == 'Any Category' ? 'Mixed' : _category,
          difficulty: difficulties[_difficulty],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quiz',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text('Questions amount: ${_amount.round()}'),
              Slider(
                value: _amount,
                min: 1,
                max: 10,
                divisions: 9,
                label: _amount.round().toString(),
                onChanged: (v) => setState(() => _amount = v),
              ),
              const SizedBox(height: 16),
              const Text('Category'),
              DropdownButton<String>(
                isExpanded: true,
                value: _category,
                items: categories.keys
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              const Text('Difficulty'),
              DropdownButton<String>(
                isExpanded: true,
                value: _difficulty,
                items: difficulties.keys
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _difficulty = v!),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _start,
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}