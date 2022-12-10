import 'package:aoc/answer10a.dart';
import 'package:test/test.dart';

void main() {
  test('10a - small input', () {
    final solver = Solver10a();

    expect(solver.key, equals('10a'));
    expect(solver.question, startsWith('What is the sum of these six signal strengths?'));

    final cpu = solver.cpu;

    cpu.execute(
      input.map(Operation.fromInput).toList(),
      (cycle, register) {
        if (cycle == 2) expect(register, equals(1));
        if (cycle == 3) expect(register, equals(1));
        if (cycle == 4) expect(register, equals(4));
        if (cycle == 5) expect(register, equals(4));
        if (cycle == 6) expect(register, equals(-1));
      },
    );

    expect(cpu.cycle, equals(6));
    expect(cpu.register, equals(-1));

    cpu.reset();
  });

  test('10a - larger input', () {
    final solver = Solver10a();

    expect(solver.key, equals('10a'));
    expect(solver.question, startsWith('What is the sum of these six signal strengths?'));

    final cpu = solver.cpu;

    cpu.execute(
      input2.map(Operation.fromInput).toList(),
      (cycle, register) {
        if (cycle == 20) expect(register, equals(21));
        if (cycle == 60) expect(register, equals(19));
        if (cycle == 100) expect(register, equals(18));
        if (cycle == 140) expect(register, equals(21));
        if (cycle == 180) expect(register, equals(16));
        if (cycle == 220) expect(register, equals(18));
      },
    );

    cpu.reset();

    final answer = solver.solve(input2);

    expect(answer, equals(13140));

    expect(() => Operation.fromInput('invalid'), throwsA(TypeMatcher<UnsupportedError>()));
  });
}

final input = <String>[
  'noop',
  'addx 3',
  'addx -5',
];

final input2 = <String>[
  'addx 15',
  'addx -11',
  'addx 6',
  'addx -3',
  'addx 5',
  'addx -1',
  'addx -8',
  'addx 13',
  'addx 4',
  'noop',
  'addx -1',
  'addx 5',
  'addx -1',
  'addx 5',
  'addx -1',
  'addx 5',
  'addx -1',
  'addx 5',
  'addx -1',
  'addx -35',
  'addx 1',
  'addx 24',
  'addx -19',
  'addx 1',
  'addx 16',
  'addx -11',
  'noop',
  'noop',
  'addx 21',
  'addx -15',
  'noop',
  'noop',
  'addx -3',
  'addx 9',
  'addx 1',
  'addx -3',
  'addx 8',
  'addx 1',
  'addx 5',
  'noop',
  'noop',
  'noop',
  'noop',
  'noop',
  'addx -36',
  'noop',
  'addx 1',
  'addx 7',
  'noop',
  'noop',
  'noop',
  'addx 2',
  'addx 6',
  'noop',
  'noop',
  'noop',
  'noop',
  'noop',
  'addx 1',
  'noop',
  'noop',
  'addx 7',
  'addx 1',
  'noop',
  'addx -13',
  'addx 13',
  'addx 7',
  'noop',
  'addx 1',
  'addx -33',
  'noop',
  'noop',
  'noop',
  'addx 2',
  'noop',
  'noop',
  'noop',
  'addx 8',
  'noop',
  'addx -1',
  'addx 2',
  'addx 1',
  'noop',
  'addx 17',
  'addx -9',
  'addx 1',
  'addx 1',
  'addx -3',
  'addx 11',
  'noop',
  'noop',
  'addx 1',
  'noop',
  'addx 1',
  'noop',
  'noop',
  'addx -13',
  'addx -19',
  'addx 1',
  'addx 3',
  'addx 26',
  'addx -30',
  'addx 12',
  'addx -1',
  'addx 3',
  'addx 1',
  'noop',
  'noop',
  'noop',
  'addx -9',
  'addx 18',
  'addx 1',
  'addx 2',
  'noop',
  'noop',
  'addx 9',
  'noop',
  'noop',
  'noop',
  'addx -1',
  'addx 2',
  'addx -37',
  'addx 1',
  'addx 3',
  'noop',
  'addx 15',
  'addx -21',
  'addx 22',
  'addx -6',
  'addx 1',
  'noop',
  'addx 2',
  'addx 1',
  'noop',
  'addx -10',
  'noop',
  'noop',
  'addx 20',
  'addx 1',
  'addx 2',
  'addx 2',
  'addx -6',
  'addx -11',
  'noop',
  'noop',
  'noop',
];
