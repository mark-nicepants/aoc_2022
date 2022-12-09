import 'package:aoc/answer9b.dart';
import 'package:test/test.dart';

void main() {
  test('9b', () {
    final solver = Solver9b();

    expect(solver.key, equals('9b'));
    expect(solver.question, startsWith('How many positions does the tail of the rope visit at least once?'));

    final answer = solver.solve(input);

    expect(answer, equals(14));
    expect(solver.grid.tailGraph(), equals(verification));

    expect(() => Direction.fromInput('invalid'), throwsA(TypeMatcher<UnsupportedError>()));
    expect(Direction.fromDelta(0, -3), equals(Direction.down));
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
  'R 20',
];

final verification = '......................\n'
    '......................\n'
    '.............987654321\n'
    '......................\n'
    '......................\n'
    '';
