import 'package:aoc/answer14a.dart';
import 'package:test/test.dart';

void main() {
  test('14a', () {
    final solver = Solver14a();

    expect(solver.key, equals('14a'));
    expect(solver.question, startsWith('Using your scan, simulate the falling sand.'));

    solver.cave.setWalls(input);

    expect(solver.cave.map(false), equals(caveMap));

    solver.cave.dropSandUnit();
    expect(solver.cave.map(true), equals(sandMap1Unit));

    solver.cave.dropSandUnit();
    expect(solver.cave.map(true), equals(sandMap2Units));

    solver.cave.dropSandUnit();
    solver.cave.dropSandUnit();
    solver.cave.dropSandUnit();
    expect(solver.cave.map(true), equals(sandMap5Units));

    while (!solver.cave.sandReachedVoid) {
      solver.cave.dropSandUnit();
    }
    expect(solver.cave.map(true), equals(endOutput));

    final answer = solver.solve(input);
    expect(answer, equals(24));

    expect(
      Point(0, 0, PointType.sand).moveTo(Point(2, 0, PointType.empty)),
      equals(Point(1, 0, PointType.sand)),
    );

    expect(
      Point(0, 0, PointType.sand).moveTo(Point(0, -5, PointType.empty)),
      equals(Point(0, -1, PointType.sand)),
    );

    expect(
      () => Point(0, 0, PointType.sand).moveTo(Point(1, 5, PointType.empty)),
      throwsA(TypeMatcher<UnsupportedError>()),
    );
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

final sandMap1Unit = [
  '......+...',
  '..........',
  '..........',
  '..........',
  '....#...##',
  '....#...#.',
  '..###...#.',
  '........#.',
  '......o.#.',
  '#########.',
];

final sandMap2Units = [
  '......+...',
  '..........',
  '..........',
  '..........',
  '....#...##',
  '....#...#.',
  '..###...#.',
  '........#.',
  '.....oo.#.',
  '#########.',
];

final sandMap5Units = [
  '......+...',
  '..........',
  '..........',
  '..........',
  '....#...##',
  '....#...#.',
  '..###...#.',
  '......o.#.',
  '....oooo#.',
  '#########.',
];
