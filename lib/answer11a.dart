import 'package:aoc/solver.dart';

/// Figure out which monkeys to chase by counting how many items they inspect over 20 rounds.
/// What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?

class Solver11a extends ISolver {
  @override
  String get key => '11a';

  @override
  String get question => 'What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?';

  final game = Game();

  @override
  int solve(List<String> input) {
    game.addMonkeys(parseMonkeyList(input));
    game.playRounds(20);

    return game.monkeyBusinessLevel();
  }
}

class Game {
  final monkeys = <Monkey>[];

  void addMonkeys(monkeys) {
    this.monkeys.addAll(monkeys);
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
        item = monkey.getsBoredWith(item);
        monkey.throws(item, monkeys);
      }
      monkey.items.clear();
    }
  }

  int monkeyBusinessLevel() {
    monkeys.sort((a, b) => b.numInspects.compareTo(a.numInspects));

    return monkeys.sublist(0, 2).map((e) => e.numInspects).reduce((value, element) => value * element);
  }

  void reset() {
    monkeys.clear();
  }
}

class Monkey {
  final int index;
  final List<int> items;
  final Operation operation;
  final int monkeyIndexIfTrue;
  final int monkeyIndexIfFalse;
  final int divisibleByTest;

  int numInspects = 0;

  Monkey(
    this.index,
    this.items,
    this.operation,
    this.monkeyIndexIfTrue,
    this.monkeyIndexIfFalse,
    this.divisibleByTest,
  );

  int inspect(int item) {
    numInspects++;
    final result = operation.execute(item);
    return result;
  }

  int getsBoredWith(int item) => item ~/ 3;

  void throws(int item, List<Monkey> otherMonkeys) {
    if (item % divisibleByTest == 0) {
      otherMonkeys[monkeyIndexIfTrue].catches(item);
    } else {
      otherMonkeys[monkeyIndexIfFalse].catches(item);
    }
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
  var index = 0;
  Operation? operation;
  int monkeyIndexIfTrue = -1;
  int monkeyIndexIfFalse = -1;
  int divisibleByTest = -1;

  for (var row in input) {
    if (row.trim().isEmpty) {
      output.add(Monkey(
        index++,
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
    index++,
    items,
    operation!,
    monkeyIndexIfTrue,
    monkeyIndexIfFalse,
    divisibleByTest,
  ));

  return output;
}
