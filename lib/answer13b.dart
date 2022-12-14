import 'dart:convert';
import 'dart:math';

import 'package:aoc/solver.dart';

class Solver13b extends ISolver {
  @override
  String get key => '13b';

  @override
  String get question => 'Organize all of the packets into the correct order.'
      'What is the decoder key for the distress signal?';

  final output = <dynamic>[];

  @override
  int solve(List<String> input) {
    for (var row in input) {
      if (row.isEmpty) continue;

      output.add(jsonDecode(row));
    }

    output.add(jsonDecode('[[2]]'));
    output.add(jsonDecode('[[6]]'));

    output.sort(comparator);

    final keyIndex1 = output.map(jsonEncode).toList().indexOf('[[2]]') + 1;
    final keyIndex2 = output.map(jsonEncode).toList().indexOf('[[6]]') + 1;

    return keyIndex1 * keyIndex2;
  }
}

int comparator(dynamic input1, dynamic input2) {
  dynamic left = input1;
  dynamic right = input2;

  if (left is num && right is num) {
    return left.compareTo(right);
  }
  if (left is num && right is List) {
    left = [left];
  }
  if (right is num && left is List) {
    right = [right];
  }

  return _compareLists(left as List, right as List);
}

int _compareLists(List l, List r) {
  final length = max(l.length, r.length);
  for (var i = 0; i < length; i++) {
    if (i >= r.length) {
      return 1;
    }
    if (i >= l.length) {
      return -1;
    }

    final childOrder = comparator(l[i], r[i]);
    if (childOrder != 0) {
      return childOrder;
    }
  }

  return 0;
}
