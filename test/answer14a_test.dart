import 'package:aoc/answer14a.dart';
import 'package:test/test.dart';

void main() {
  test('14a', () {
    final solver = Solver14a();

    expect(solver.key, equals('14a'));
    expect(solver.question, startsWith('Using your scan, simulate the falling sand.'));

    final answer = solver.solve(input);

    expect(answer, equals(24));

    expect(solver.cave.map(false), equals(caveMap));
    expect(solver.cave.map(true), equals(caveMap));
  });
}

final input = [
  '498,4 -> 498,6 -> 496,6',
  '503,4 -> 502,4 -> 502,9 -> 494,9',
];

final caveMap = [
  '......+...',
  '..........',
  '..........',
  '..........',
  '....#...##',
  '....#...#.',
  '..###...#.',
  '........#.',
  '........#.',
  '#########.',
];

final endOutput = [
  '......+...',
  '..........',
  '......o...',
  '.....ooo..',
  '....#ooo##',
  '...o#ooo#.',
  '..###ooo#.',
  '....oooo#.',
  '.o.ooooo#.',
  '#########.',
];
