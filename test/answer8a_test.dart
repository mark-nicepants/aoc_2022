import 'package:aoc/answer8a.dart';
import 'package:test/test.dart';

void main() {
  test('8a', () {
    final solver = Solver8a();

    expect(solver.key, equals('8a'));
    expect(solver.question, startsWith('Consider your map; how many trees are visible'));

    final answer = solver.solve(input);

    final grid = solver.grid;
    expect(grid?.coord(1, 1).value, equals(5));
    expect(grid?.coord(1, 1).visibility, equals([Side.left, Side.top]));

    expect(grid?.coord(2, 1).value, equals(5));
    expect(grid?.coord(2, 1).visibility, equals([Side.right, Side.top]));

    expect(grid?.coord(3, 1).value, equals(1));
    expect(grid?.coord(3, 1).visibility, equals([]));

    expect(grid?.coord(1, 2).value, equals(5));
    expect(grid?.coord(1, 2).visibility, equals([Side.right]));

    expect(grid?.coord(2, 2).value, equals(3));
    expect(grid?.coord(2, 2).visibility, equals([]));

    expect(grid?.coord(3, 2).value, equals(3));
    expect(grid?.coord(3, 2).visibility, equals([Side.right]));

    expect(grid?.coord(1, 3).value, equals(3));
    expect(grid?.coord(1, 3).visibility, equals([]));

    expect(grid?.coord(2, 3).value, equals(5));
    expect(grid?.coord(2, 3).visibility, equals([Side.bottom, Side.left]));

    expect(grid?.coord(3, 3).value, equals(4));
    expect(grid?.coord(3, 3).visibility, equals([]));

    expect(answer, equals(21));
  });
}

final input = <String>[
  '30373',
  '25512',
  '65332',
  '33549',
  '35390',
];
