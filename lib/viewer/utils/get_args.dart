import 'package:flutter/widgets.dart';

extension GetArgument on BuildContext {
  T? getArgument<T>() => ModalRoute.of(this)?.settings.arguments as T?;
}
