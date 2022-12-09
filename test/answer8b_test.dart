import 'package:aoc/answer8b.dart';
import 'package:test/test.dart';

void main() {
  test('8b', () {
    final solver = Solver8b();

    expect(solver.key, equals('8b'));
    expect(solver.question, startsWith('What is the highest scenic score possible for any tree?'));

    final answer = solver.solve(input);

    final grid = solver.grid;

    expect(grid?.coord(2, 1).value, equals(5));
    expect(grid?.coord(2, 1).scenicScore, equals(4));

    expect(grid?.coord(2, 3).value, equals(5));
    expect(grid?.coord(2, 3).scenicScore, equals(8));

    expect(answer, equals(8));
  });
}

final input = <String>[
  '30373',
  '25512',
  '65332',
  '33549',
  '35390',
];
