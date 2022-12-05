import 'package:aoc/answer4a.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('4a. In how many assignment pairs does one range fully contain the other?', () {
    final solver = Solver4a();

    expect(solver.key, '4a');
    expect(solver.question, startsWith('In how many assignment pairs does'));

    expect(2, same(solver.solve(input)));
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
