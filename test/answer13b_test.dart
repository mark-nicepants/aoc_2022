import 'dart:convert';

import 'package:aoc/answer13b.dart';
import 'package:test/test.dart';

void main() {
  test('13b', () {
    final solver = Solver13b();

    expect(solver.key, equals('13b'));
    expect(solver.question, startsWith('Organize all of the packets into the correct order.'));

    final answer = solver.solve(input);

    expect(solver.output.map(jsonEncode), equals(output));
    expect(answer, equals(140));
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

final output = [
  '[]',
  '[[]]',
  '[[[]]]',
  '[1,1,3,1,1]',
  '[1,1,5,1,1]',
  '[[1],[2,3,4]]',
  '[1,[2,[3,[4,[5,6,0]]]],8,9]',
  '[1,[2,[3,[4,[5,6,7]]]],8,9]',
  '[[1],4]',
  '[[2]]',
  '[3]',
  '[[4,4],4,4]',
  '[[4,4],4,4,4]',
  '[[6]]',
  '[7,7,7]',
  '[7,7,7,7]',
  '[[8,7,6]]',
  '[9]',
];
