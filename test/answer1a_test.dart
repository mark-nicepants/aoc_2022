import 'package:aoc/answer1a.dart';
import 'package:test/test.dart';

void main() {
  test('1a. If we found the right elf', () {
    final solver = Solver1a();

    expect(5000, same(solver.solve(input1)));
    expect(6200, same(solver.solve(input2)));
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
