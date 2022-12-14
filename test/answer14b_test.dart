import 'package:aoc/answer14b.dart';
import 'package:test/test.dart';

void main() {
  test('14b', () {
    final solver = Solver14b();

    expect(solver.key, equals('14b'));
    expect(solver.question, contains('falling sand until the source of the sand becomes blocked.'));

    final answer = solver.solve(input);

    expect(solver.cave.map(true), equals(endOutput));
    expect(answer, equals(93));
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
  '..........o..........',
  '.........ooo.........',
  '........ooooo........',
  '.......ooooooo.......',
  '......oo#ooo##o......',
  '.....ooo#ooo#ooo.....',
  '....oo###ooo#oooo....',
  '...oooo.oooo#ooooo...',
  '..oooooooooo#oooooo..',
  '.ooo#########ooooooo.',
  'ooooo.......ooooooooo',
  '#####################',
];
