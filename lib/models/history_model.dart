class HistoryModel {
  final dynamic key;
  final String category;
  final String difficulty;
  final int correct;
  final int total;
  final DateTime date;

  HistoryModel({
    this.key,
    required this.category,
    required this.difficulty,
    required this.correct,
    required this.total,
    required this.date,
  });

  int get percent => total == 0 ? 0 : (correct / total * 100).round();

  String get dateText {
    const months = [
      'jan', 'feb', 'mar', 'apr', 'may', 'jun',
      'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  Map<String, dynamic> toMap() => {
        'category': category,
        'difficulty': difficulty,
        'correct': correct,
        'total': total,
        'date': date.millisecondsSinceEpoch,
      };

  factory HistoryModel.fromMap(Map<String, dynamic> map, {dynamic key}) {
    return HistoryModel(
      key: key,
      category: map['category'] as String,
      difficulty: map['difficulty'] as String,
      correct: map['correct'] as int,
      total: map['total'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}