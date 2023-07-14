import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class CachedPage {
  final int pageNumber;
  final Size size;
  final String path;

  const CachedPage({
    required this.pageNumber,
    required this.size,
    required this.path,
  });

  @override
  String toString() =>
      'CachedPage(pageNumber: $pageNumber, size: $size, path: $path)';

  @override
  bool operator ==(covariant CachedPage other) {
    if (identical(this, other)) return true;

    return other.pageNumber == pageNumber &&
        other.size == size &&
        other.path == path;
  }

  @override
  int get hashCode => pageNumber.hashCode ^ size.hashCode ^ path.hashCode;
}
