import 'package:aoc/answer11a.dart';
import 'package:test/test.dart';

void main() {
  test('11a', () {
    final solver = Solver11a();

    expect(solver.key, equals('11a'));
    expect(solver.question, startsWith('What is the level of monkey business after 20 rounds'));

    final game = solver.game;
    final monkeys = parseMonkeyList(input);

    game.addMonkeys(monkeys);

    game.playRound();
    expect(monkeys[0].items, equals([20, 23, 27, 26]));
    expect(monkeys[1].items, equals([2080, 25, 167, 207, 401, 1046]));
    expect(monkeys[2].items, equals([]));
    expect(monkeys[3].items, equals([]));

    game.playRound();
    expect(monkeys[0].items, equals([695, 10, 71, 135, 350]));
    expect(monkeys[1].items, equals([43, 49, 58, 55, 362]));
    expect(monkeys[2].items, equals([]));
    expect(monkeys[3].items, equals([]));

    game.playRounds(18);
    expect(monkeys[0].items, equals([10, 12, 14, 26, 34]));
    expect(monkeys[1].items, equals([245, 93, 53, 199, 115]));
    expect(monkeys[2].items, equals([]));
    expect(monkeys[3].items, equals([]));

    expect(monkeys[0].numInspects, equals(101));
    expect(monkeys[1].numInspects, equals(95));
    expect(monkeys[2].numInspects, equals(7));
    expect(monkeys[3].numInspects, equals(105));

    game.reset();

    final answer = solver.solve(input);
    expect(answer, equals(10605));

    expect(
      () => Operation('old / 2').execute(5),
      throwsA(TypeMatcher<UnsupportedError>()),
    );
  });
}

final input = [
  'Monkey 0:',
  '  Starting items: 79, 98',
  '  Operation: new = old * 19',
  '  Test: divisible by 23',
  '    If true: throw to monkey 2',
  '    If false: throw to monkey 3',
  '',
  'Monkey 1:',
  '  Starting items: 54, 65, 75, 74',
  '  Operation: new = old + 6',
  '  Test: divisible by 19',
  '    If true: throw to monkey 2',
  '    If false: throw to monkey 0',
  '',
  'Monkey 2:',
  '  Starting items: 79, 60, 97',
  '  Operation: new = old * old',
  '  Test: divisible by 13',
  '    If true: throw to monkey 1',
  '    If false: throw to monkey 3',
  '',
  'Monkey 3:',
  '  Starting items: 74',
  '  Operation: new = old + 3',
  '  Test: divisible by 17',
  '    If true: throw to monkey 0',
  '    If false: throw to monkey 1',
];
