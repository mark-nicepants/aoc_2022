import 'package:aoc/answer2b.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('2b. Calculate my tournament score', () {
    final solver = Solver2b();

    expect(12, same(solver.solve(input1)));
  });
}

final input1 = [
  'A Y',
  'B X',
  'C Z',
];
