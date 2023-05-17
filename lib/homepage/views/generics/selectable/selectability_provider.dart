import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/utils/range_utils.dart';

class SelectabilityModel extends ChangeNotifier {
  SelectabilityModel();

  final _selectedIndexes = <int>{};
  Set<int> get selectedIndexes => Set.unmodifiable(_selectedIndexes);

  int? _indexCount;
  int? get indexCount => _indexCount;
  void setIndexCount(int count) {
    _indexCount ??= count;
  }

  void addIndex(int index) => _selectedIndexes.add(index);
  void removeIndex(int index) => _selectedIndexes.remove(index);

  void selectMany(List<int> indexes) {
    for (int index in indexes) {
      addIndex(index);
    }
    super.notifyListeners();
  }

  void clear() {
    _selectedIndexes.clear();
    super.notifyListeners();
  }

  void onTap(int index) {
    _selectedIndexes.contains(index) ? removeIndex(index) : addIndex(index);
    super.notifyListeners();
  }

  String get selectedIndexesRangeString =>
      RangeUtils.generateRangeString(_selectedIndexes.toList());
}

final selectabilityProvider =
    ChangeNotifierProvider((ref) => SelectabilityModel());
