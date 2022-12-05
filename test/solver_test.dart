import 'package:aoc/solver.dart';
import 'package:test/test.dart';

void main() {
  test('Test the ISolver print method', () {
    final solver = TestSolver();

    expect('test. What is the answer?\n\nAnswer = 42', equals(solver.printSolve(['21', '21'])));
  });
}

class TestSolver extends ISolver {
  @override
  String get key => 'test';

  @override
  String get question => 'What is the answer?';

  @override
  int solve(List<String> input) {
    return input.map(int.parse).reduce((value, element) => value + element);
  }
}
