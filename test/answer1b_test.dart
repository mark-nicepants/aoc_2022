import 'package:aoc/answer1b.dart';
import 'package:test/test.dart';

void main() {
  test('If we found the elf with the most calories', () {
    final solver = Solver1b();

    expect(10000, same(solver.solve(input1)));
    expect(9200, same(solver.solve(input2)));
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
  "5",
];

final input2 = [
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
