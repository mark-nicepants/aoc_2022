import 'dart:convert';
import 'dart:math';

import 'package:aoc/solver.dart';

class Solver13a extends ISolver {
  @override
  String get key => '13a';

  @override
  String get question => 'Determine which pairs of packets are already in the right order.'
      'What is the sum of the indices of those pairs?';

  final pairs = <Pair>[];

  @override
  int solve(List<String> input) {
    for (int i = 0; i < input.length; i += 3) {
      final inputs = input.skip(i).take(2).toList();

      final left = jsonDecode(inputs[0]);
      final right = jsonDecode(inputs[1]);

      pairs.add(Pair(0, left, right));
    }

    return pairs
        .asMap()
        .map((i, value) => MapEntry(i, value.inOrder == -1 ? i + 1 : null))
        .values
        .where((element) => element != null)
        .cast<int>()
        .reduce((value, element) => value + element);
  }
}

class Pair {
  final int level;
  final dynamic input1;
  final dynamic input2;

  Pair(this.level, this.input1, this.input2);

  int get inOrder {
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

      final childOrder = Pair(level + 1, l[i], r[i]).inOrder;
      if (childOrder != 0) {
        return childOrder;
      }
    }

    return 0;
  }
}
