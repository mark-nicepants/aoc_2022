import 'package:aoc/answer13a.dart';
import 'package:test/test.dart';

void main() {
  test('13a', () {
    final solver = Solver13a();

    expect(solver.key, equals('13a'));
    expect(solver.question, startsWith('Determine which pairs of packets are already in the right order.'));

    final answer = solver.solve(input);

    expect(solver.pairs.length, equals(8));

    expect(answer, equals(13));
  });
}

final input = [
  '[1,1,3,1,1]',
  '[1,1,5,1,1]',
  '',
  '[[1],[2,3,4]]',
  '[[1],4]',
  '',
  '[9]',
  '[[8,7,6]]',
  '',
  '[[4,4],4,4]',
  '[[4,4],4,4,4]',
  '',
  '[7,7,7,7]',
  '[7,7,7]',
  '',
  '[]',
  '[3]',
  '',
  '[[[]]]',
  '[[]]',
  '',
  '[1,[2,[3,[4,[5,6,7]]]],8,9]',
  '[1,[2,[3,[4,[5,6,0]]]],8,9]',
];
