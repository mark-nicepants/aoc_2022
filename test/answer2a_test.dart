import 'package:aoc/answer2a.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Calculate my tournament score', () {
    final solver = Solver2a();

    expect(15, same(solver.solve(input1)));
  });
}

final input1 = [
  'A Y',
  'B X',
  'C Z',
];
