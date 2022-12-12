import 'package:aoc/answer12b.dart';
import 'package:test/test.dart';

void main() {
  test('12b', () {
    final solver = Solver12b();

    expect(solver.key, equals('12b'));
    expect(solver.question, startsWith('What is the fewest steps required'));

    final answer = solver.solve(input);

    expect(answer, equals(29));

    // For them sweet 100% coverage
    final tiles = HeightMap.fromInput(input).tiles;
    expect(TileNetwork(tiles).allNodes.toList(), equals(tiles));
  });
}

final input = [
  'aabqponm',
  'abcryxxl',
  'accszExk',
  'acctuvwj',
  'Sbdefghi',
];
