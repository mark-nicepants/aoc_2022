import 'package:aoc/answer2b.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('2b. Calculate my tournament score', () {
    final solver = Solver2b();

    expect(solver.key, '2b');
    expect(solver.question, startsWith('Following the Elf\'s instructions for the second column'));

    expect(12, same(solver.solve(input1)));

    expect(() => Play.fromString('invalid'), throwsA(TypeMatcher<UnsupportedError>()));
    expect(() => Result.fromString('invalid'), throwsA(TypeMatcher<UnsupportedError>()));

    // * Catch missing conditions
    expect(Play.rock.winsFrom(Play.sissors), equals(Result.win));
    expect(Play.paper.winsFrom(Play.paper), equals(Result.draw));
    expect(Play.paper.winsFrom(Play.sissors), equals(Result.lose));
    expect(Play.sissors.winsFrom(Play.sissors), equals(Result.draw));
    expect(Play.sissors.winsFrom(Play.paper), equals(Result.win));
    expect(Play.sissors.winsFrom(Play.rock), equals(Result.lose));

    expect(Play.rock.playValue, equals(1));
    expect(Play.paper.playValue, equals(2));
    expect(Play.sissors.playValue, equals(3));

    expect(Play.fromWinCondition(Result.draw.inputValue, Play.paper.inputValue), equals(Play.paper));
    expect(Play.fromWinCondition(Result.lose.inputValue, Play.sissors.inputValue), equals(Play.paper));
    expect(Play.fromWinCondition(Result.draw.inputValue, Play.sissors.inputValue), equals(Play.sissors));
  });
}

final input1 = [
  'A Y',
  'B X',
  'C Z',
];
