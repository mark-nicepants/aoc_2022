import 'package:aoc/answer12a.dart';
import 'package:test/test.dart';

void main() {
  test('12a', () {
    final solver = Solver12a();

    expect(solver.key, equals('12a'));
    expect(solver.question, startsWith('What is the fewest steps required'));

    final answer = solver.solve(input);

    expect(answer, equals(31));

    // For them sweet 100% coverage
    final tiles = HeightMap.fromInput(input).tiles;
    expect(TileNetwork(tiles).allNodes.toList(), equals(tiles));
  });
}

final input = [
  'Sabqponm',
  'abcryxxl',
  'accszExk',
  'acctuvwj',
  'abdefghi',
];
