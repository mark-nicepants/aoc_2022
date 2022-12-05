import 'package:aoc/answer1a.dart';
import 'package:test/test.dart';

void main() {
  test('1a. If we found the right elf', () {
    final solver = Solver1a();

    expect(solver.solve(input1), same(5000));
    expect(solver.solve(input2), same(6200));

    expect(solver.key, '1a');
    expect(solver.question, startsWith('Find the Elf carrying'));
  });
}

final input1 = [
  "200",
  "600",
  "",
  "200",
  "600",
  "4200",
  "",
  "200",
  "600",
  "3400",
  "",
];

final input2 = [
  "200",
  "6000",
  "",
  "200",
  "600",
  "4200",
  "",
  "200",
  "600",
  "3400",
  "",
];
