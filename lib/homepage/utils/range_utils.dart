import 'package:flutter/foundation.dart';

@immutable
class RangeUtils {
  // coverts list of numbers to range string
  // For example:
  // [1, 2, 3, 5, 8, 9] => 1-3,5,8-9
  static String generateRangeString(List<int> numbers) {
    numbers.sort();
    if (numbers.isEmpty) {
      return '';
    }
    List<String> ranges = [];
    int start = numbers[0];
    int end = start;

    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] == end + 1) {
        end = numbers[i];
      } else {
        if (start == end) {
          ranges.add('$start');
        } else {
          ranges.add('$start-$end');
        }
        start = end = numbers[i];
      }
    }

    if (start == end) {
      ranges.add('$start');
    } else {
      ranges.add('$start-$end');
    }
    return ranges.join(',');
  }

  // coverts range string to list of numbers
  // For example:
  //  1-3,5,8-9 => [1, 2, 3, 5, 8, 9]
  static Iterable<int> parseRangeString(String rangeString) {
    try {
      return rangeString.split(',').map(
        (range) {
          final rangeList =
              range.split('-').map((element) => int.parse(element));
          if (rangeList.length > 1) {
            return [for (int i = rangeList.first; i <= rangeList.last; i++) i];
          }
          return rangeList;
        },
      ).expand((element) => element);
    } catch (e) {
      throw const RangeUtilsException();
    }
  }

  const RangeUtils._();
}

@immutable
class RangeUtilsException implements Exception {
  const RangeUtilsException();
}
