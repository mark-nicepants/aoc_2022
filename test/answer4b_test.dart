import 'package:aoc/answer4b.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('4b. In how many assignment pairs do the ranges overlap?', () {
    final solver = Solver4b();

    expect(solver.key, '4b');
    expect(solver.question, startsWith('In how many assignment pairs do the ranges overlap'));

    expect(4, same(solver.solve(input)));
  });
}

final input = [
  '2-4,6-8',
  '2-3,4-5',
  '5-7,7-9',
  '2-8,3-7',
  '6-6,4-6',
  '2-6,4-8',
];
