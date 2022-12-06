import 'package:aoc/answer6b.dart';
import 'package:test/test.dart';

void main() {
  test('6b ', () {
    final solver = Solver6b();

    expect(solver.key, equals('6b'));
    expect(solver.question, startsWith('How many characters need to be processed'));

    input.forEach((key, value) {
      final answer = solver.solve([key]);

      expect(answer, equals(value));
    });
  });
}

final input = {
  "mjqjpqmgbljsphdztnvjfqwrcgsmlb": 19,
  "bvwbjplbgvbhsrlpgdmjqwftvncz": 23,
  "nppdvjthqldpwncqszvftbrmjlhg": 23,
  "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg": 29,
  "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw": 26,
  "zcfzfwazqfrljwalrfnpddbatmacgvaw": -1,
};
