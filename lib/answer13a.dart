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
      pairs.add(Pair(0, inputs[0], inputs[1]));
    }

    int sumOfInOrder = 0;
    for (var i = 0; i < pairs.length; i++) {
      print('Pair index $i');
      if (pairs[i].inOrder == -1) {
        sumOfInOrder += (i + 1);
      }
      print('');
    }

    return sumOfInOrder;
  }
}

class Pair {
  final int level;
  final String input1;
  final String input2;

  Pair(this.level, this.input1, this.input2);

  String get indent => List.filled(level, '  ').join('');

  int get inOrder {
    print('$indent- Compare: $input1 vs $input2');

    String left = input1;
    String right = input2;

    if (_bothInt(left, right)) {
      return _compareInts(left, right);
    } else {
      if (_isInt(left) && _isList(right)) {
        print('$indent  - Mixed types; convert left to [$left] and retry');
        left = "[$left]";
      }
      if (_isInt(right) && _isList(left)) {
        print('$indent  - Mixed types; convert right to [$right] and retry');
        right = "[$right]";
      }

      return _compareLists(left, right);
    }
  }

  bool _isInt(String input) => int.tryParse(input) != null;

  bool _isList(String input) => input.startsWith('[');

  bool _bothInt(String left, String right) => _isInt(left) && _isInt(right);

  int _compareInts(String left, String right) {
    final l = int.parse(left);
    final r = int.parse(right);

    if (l < r) {
      print('$indent  - Left side is smaller, so inputs are in the right order');
    } else if (l > r) {
      print('$indent  - Right side is smaller, so inputs are not in the right order');
    }

    return l.compareTo(r);
  }

  int _compareLists(String left, String right) {
    final l = parseStringAsList(left);
    final r = parseStringAsList(right);

    for (var i = 0; i < l.length; i++) {
      if (i >= r.length) {
        print('$indent  - Right side ran out of items, so inputs are not in the right order');
        return 1;
      }

      final childOrder = Pair(level + 1, l[i], r[i]).inOrder;
      if (childOrder != 0) {
        return childOrder;
      }
    }

    // If the left list runs out of items first, right order
    if (l.length < r.length) {
      print('$indent  - Left side ran out of items, so inputs are in the right order');
      return -1;
    }

    return 0;
  }
}

List<String> parseStringAsList(String input) {
  String value = '';
  int listIndex = 0;
  final items = <String>[];

  input.substring(1, input.length - 1).split('').forEach((char) {
    if (char == ',' && listIndex == 0) {
      items.add(value);
      value = '';
    } else {
      if (char == '[') {
        listIndex++;
      } else if (char == ']') {
        listIndex--;
      }
      value += char;
    }
  });

  if (value.isNotEmpty) {
    items.add(value);
  }

  return items;
}
