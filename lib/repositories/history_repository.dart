import 'package:hive/hive.dart';
import '../models/history_model.dart';

class HistoryRepository {
  Box get _box => Hive.box('history');

  Future<void> save(HistoryModel item) => _box.add(item.toMap());

  // новые сверху
  List<HistoryModel> getAll() {
    return _box.keys.toList().reversed.map((key) {
      final map = Map<String, dynamic>.from(_box.get(key) as Map);
      return HistoryModel.fromMap(map, key: key);
    }).toList();
  }

  Future<void> delete(dynamic key) => _box.delete(key);
}