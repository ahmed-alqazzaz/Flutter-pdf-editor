import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'english_contractions.dart';

@immutable
class Contractions {
  const Contractions._();
  static const english = EnglishContractions();
}
