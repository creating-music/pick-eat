import '../models/menu.dart';

abstract class HistoryService {
  Future<void> addHistory(Menu menu);
  Future<List<Menu>> getHistory();
}

class MemoryHistoryService implements HistoryService {
  final List<Menu> _history = [];

  @override
  Future<void> addHistory(Menu menu) async {
    _history.add(menu);
  }

  @override
  Future<List<Menu>> getHistory() async {
    return _history;
  }
}
