import 'package:aoc/answer9a.dart';
import 'package:test/test.dart';

void main() {
  test('9a', () {
    final solver = Solver9a();

    expect(solver.key, equals('9a'));
    expect(solver.question, startsWith('How many positions does the tail of the rope visit at least once?'));

    final answer = solver.solve(input);

    expect(answer, equals(13));
    expect(solver.grid.tailGraph(), equals(verification));

    expect(() => Direction.fromInput('invalid'), throwsA(TypeMatcher<UnsupportedError>()));
  });
}

final input = <String>[
  'R 4',
  'U 4',
  'L 3',
  'D 1',
  'R 4',
  'D 1',
  'L 5',
  'R 2',
];

final verification = '''..##.
...##
.####
....#
s###.
''';
