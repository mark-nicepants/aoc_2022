import 'package:aoc/answer2a.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('2a. Calculate my tournament score', () {
    final solver = Solver2a();

    expect(solver.key, '2a');
    expect(solver.question, startsWith('What would your total score be'));

    expect(15, same(solver.solve(input1)));

    expect(() => Play.fromString('invalid'), throwsA(TypeMatcher<UnsupportedError>()));

    // * Catch missing conditions
    expect(Play.rock.winsFrom(Play.sissors), equals(Result.win));
    expect(Play.paper.winsFrom(Play.paper), equals(Result.draw));
    expect(Play.paper.winsFrom(Play.sissors), equals(Result.lose));
    expect(Play.sissors.winsFrom(Play.sissors), equals(Result.draw));
    expect(Play.sissors.winsFrom(Play.paper), equals(Result.win));
    expect(Play.sissors.winsFrom(Play.rock), equals(Result.lose));
  });
}

final input1 = [
  'A Y',
  'B X',
  'C Z',
];
