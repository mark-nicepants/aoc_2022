import 'package:aoc/answer6a.dart';
import 'package:test/test.dart';

void main() {
  test('6a ', () {
    final solver = Solver6a();

    expect(solver.key, equals('6a'));
    expect(solver.question, startsWith('How many characters need to be processed'));

    input.forEach((key, value) {
      final answer = solver.solve([key]);

      expect(answer, equals(value));
    });
  });
}

final input = {
  "bvwbjplbgvbhsrlpgdmjqwftvncz": 5,
  "nppdvjthqldpwncqszvftbrmjlhg": 6,
  "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg": 10,
  "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw": 11,
  "zcfzfwzzqfzzjzzlrzzqqbbhttsccvvz": -1,
};
