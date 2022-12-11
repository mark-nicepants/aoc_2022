import 'package:aoc/answer11b.dart';
import 'package:test/test.dart';

void main() {
  test('11b', () {
    final solver = Solver11b();

    expect(solver.key, equals('11b'));
    expect(solver.question, startsWith('What is the level of monkey business after 10000 rounds?'));

    expect(() => Operation('old / 2').execute(5), throwsA(TypeMatcher<UnsupportedError>()));

    final game = Game();
    game.addMonkeys(parseMonkeyList(input));

    // After round 1
    game.playRound();
    expectMonkeyInspects(game.monkeys, 2, 4, 3, 6);

    // After round 2
    game.playRound();
    expectMonkeyInspects(game.monkeys, 6, 10, 3, 10);

    // After round 3
    game.playRound();
    expectMonkeyInspects(game.monkeys, 12, 14, 3, 16);

    // After 20
    game.playRounds(17);
    expectMonkeyInspects(game.monkeys, 99, 97, 8, 103);

    // After 1000
    game.playRounds(980);
    expectMonkeyInspects(game.monkeys, 5204, 4792, 199, 5192);

    final answer = solver.solve(input);
    expect(answer, equals(2713310158));
  });
}

void expectMonkeyInspects(List<Monkey> monkeys, i0, i1, i2, i3) {
  expect(monkeys[0].numInspects, equals(i0));
  expect(monkeys[1].numInspects, equals(i1));
  expect(monkeys[2].numInspects, equals(i2));
  expect(monkeys[3].numInspects, equals(i3));
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
