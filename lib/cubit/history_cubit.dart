import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/history_model.dart';
import '../repositories/history_repository.dart';

class HistoryCubit extends Cubit<List<HistoryModel>> {
  final HistoryRepository repository;

  HistoryCubit(this.repository) : super([]);

  void load() => emit(repository.getAll());

  Future<void> delete(dynamic key) async {
    await repository.delete(key);
    load();
  }
}