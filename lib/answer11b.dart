import 'package:aoc/solver.dart';

/// Worry levels are no longer divided by three after each item is inspected;
/// you'll need to find another way to keep your worry levels manageable.
///
/// Starting again from the initial state in your puzzle input,
/// what is the level of monkey business after 10000 rounds?
class Solver11b extends ISolver {
  @override
  String get key => '11b';

  @override
  String get question => 'What is the level of monkey business after 10000 rounds?';

  final game = Game();

  @override
  int solve(List<String> input) {
    game.addMonkeys(parseMonkeyList(input));
    game.playRounds(10000);

    return game.monkeyBusinessLevel();
  }
}

class Game {
  final monkeys = <Monkey>[];

  // https://www.calculatorsoup.com/calculators/math/lcm.php
  int leastCommonDivisor(int a, int b) => (a * b) ~/ a.gcd(b);

  // Monkeys be trippin'
  int monkeyLcd = 0;

  void addMonkeys(monkeys) {
    this.monkeys.addAll(monkeys);
    monkeyLcd = this.monkeys.map((m) => m.divisibleByTest).reduce(leastCommonDivisor);
  }

  void playRounds(int num) {
    for (var i = 0; i < num; i++) {
      playRound();
    }
  }

  void playRound() {
    for (final monkey in monkeys) {
      for (final i in monkey.items) {
        var item = i;
        item = monkey.inspect(i);
        item = monkey.getsBoredWith(item, monkeyLcd);
        monkey.throws(item, monkeys);
      }
      monkey.items.clear();
    }
  }

  int monkeyBusinessLevel() {
    monkeys.sort((a, b) => b.numInspects.compareTo(a.numInspects));

    return monkeys.take(2).map((e) => e.numInspects).reduce((value, element) => value * element);
  }
}

class Monkey {
  final List<int> items;
  final Operation operation;
  final int monkeyIndexIfTrue;
  final int monkeyIndexIfFalse;
  final int divisibleByTest;

  int numInspects = 0;

  Monkey(
    this.items,
    this.operation,
    this.monkeyIndexIfTrue,
    this.monkeyIndexIfFalse,
    this.divisibleByTest,
  );

  int getsBoredWith(int item, int easyModulo) => item % easyModulo;

  int inspect(int item) {
    numInspects++;
    return operation.execute(item);
  }

  void throws(int item, List<Monkey> otherMonkeys) {
    final receiver = item % divisibleByTest == 0 ? monkeyIndexIfTrue : monkeyIndexIfFalse;
    otherMonkeys[receiver].catches(item);
  }

  void catches(int item) {
    items.add(item);
  }
}

class Operation {
  final String raw;

  Operation(this.raw);

  int execute(int old) {
    final parts = raw.split(' ');

    final int left = old;
    final int right;
    if (parts[2] == 'old') {
      right = old;
    } else {
      right = int.parse(parts[2]);
    }

    if (parts[1] == '+') {
      return left + right;
    }
    if (parts[1] == '*') {
      return left * right;
    }
    throw UnsupportedError('Operation not supported (${parts[0]})');
  }
}

List<Monkey> parseMonkeyList(List<String> input) {
  final output = <Monkey>[];

  var items = <int>[];
  Operation? operation;
  int monkeyIndexIfTrue = -1;
  int monkeyIndexIfFalse = -1;
  int divisibleByTest = -1;

  for (var row in input) {
    if (row.trim().isEmpty) {
      output.add(Monkey(
        items,
        operation!,
        monkeyIndexIfTrue,
        monkeyIndexIfFalse,
        divisibleByTest,
      ));
    }

    if (row.contains("Starting items")) {
      items = row.split(":")[1].split(",").map((i) => int.parse(i.trim())).toList();
    }
    if (row.contains("Operation")) {
      operation = Operation(row.split("=")[1].trim());
    }
    if (row.contains("Test")) {
      divisibleByTest = int.parse(row.split(' by ')[1].trim());
    }
    if (row.contains('If true:')) {
      monkeyIndexIfTrue = int.parse(row.split('monkey')[1].trim());
    }
    if (row.contains('If false:')) {
      monkeyIndexIfFalse = int.parse(row.split('monkey')[1].trim());
    }
  }

  output.add(Monkey(
    items,
    operation!,
    monkeyIndexIfTrue,
    monkeyIndexIfFalse,
    divisibleByTest,
  ));

  return output;
}
