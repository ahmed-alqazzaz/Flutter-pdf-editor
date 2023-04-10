import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarVisibilityModel extends ChangeNotifier {
  bool _areAppbarsVisibile = false;
  bool get areAppbarsVisibile => _areAppbarsVisibile;
  void showAppBars() {
    _areAppbarsVisibile = true;
    notifyListeners();
  }

  void hideAppbars() {
    _areAppbarsVisibile = false;
    notifyListeners();
  }
}

final appbarVisibilityProvider = ChangeNotifierProvider<AppBarVisibilityModel>(
  (ref) => AppBarVisibilityModel(),
);
