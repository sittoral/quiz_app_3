import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/history_model.dart';
import '../repositories/history_repository.dart';

class ResultCubit extends Cubit<HistoryModel> {
  final HistoryRepository repository;

  ResultCubit({required this.repository, required HistoryModel result})
      : super(result) {
    repository.save(result);
  }
} 