import 'package:aoc/answer15a.dart';
import 'package:test/test.dart';

void main() {
  test('15a', () {
    final solver = Solver15a(10);

    expect(solver.key, equals('15a'));
    expect(solver.question, startsWith('Consult the report from the sensors you just deployed.'));

    final sensors = <Sensor>[];
    final grid = Grid();
    solver.parseInput(input, sensors, grid);

    final coverage = grid.coverage(sensors);
    print(coverage.join('\n'));

    print('\n');
    print(coverage[grid.rowIndex(10)]);
    print(coverage[grid.rowIndex(10)].split('').where((element) => element == '#').length);
    print('\n');
    print(grid.coverageForRow(10, sensors));
    print(grid.unavailableSpaces(10, sensors));

    final answer = solver.solve(input);
    expect(answer, equals(26));
  });
}

final input = [
  'Sensor at x=2, y=18: closest beacon is at x=-2, y=15',
  'Sensor at x=9, y=16: closest beacon is at x=10, y=16',
  'Sensor at x=13, y=2: closest beacon is at x=15, y=3',
  'Sensor at x=12, y=14: closest beacon is at x=10, y=16',
  'Sensor at x=10, y=20: closest beacon is at x=10, y=16',
  'Sensor at x=14, y=17: closest beacon is at x=10, y=16',
  'Sensor at x=8, y=7: closest beacon is at x=2, y=10',
  'Sensor at x=2, y=0: closest beacon is at x=2, y=10',
  'Sensor at x=0, y=11: closest beacon is at x=2, y=10',
  'Sensor at x=20, y=14: closest beacon is at x=25, y=17',
  'Sensor at x=17, y=20: closest beacon is at x=21, y=22',
  'Sensor at x=16, y=7: closest beacon is at x=15, y=3',
  'Sensor at x=14, y=3: closest beacon is at x=15, y=3',
  'Sensor at x=20, y=1: closest beacon is at x=15, y=3',
];
