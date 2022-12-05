import 'package:aoc/solver.dart';

/*
Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

Following the Elf's instructions for the second column, what would your total score be if everything 
goes exactly according to your strategy guide?
*/

class Solver2b extends ISolver {
  @override
  String get key => '2b';

  @override
  String get question => 'Following the Elf\'s instructions for the second column,\n'
      'what would your total score be if everything goes exactly according to your strategy guide?';

  @override
  int solve(List<String> input) {
    final games = input.map((e) {
      final plays = e.split(' ');
      return Game(plays[1], plays[0]);
    });

    return games.map((e) => e.score).reduce((value, element) => value + element);
  }
}

class Game {
  final Play my;
  final Play opponent;

  Game(
    String expectedResult,
    String opponentValue,
  )   : my = Play.fromWinCondition(expectedResult, opponentValue),
        opponent = Play.fromString(opponentValue);

  Result get result => my.winsFrom(opponent);

  int get score => result.winValue + my.playValue;
}

enum Play {
  rock('A'),
  paper('B'),
  sissors('C');

  factory Play.fromString(String value) {
    if (Play.rock.inputValue == value) return Play.rock;
    if (Play.paper.inputValue == value) return Play.paper;
    if (Play.sissors.inputValue == value) return Play.sissors;
    throw UnsupportedError('Invalid input for generating play -> $value');
  }

  factory Play.fromWinCondition(String expectedResult, String opponentValue) {
    final result = Result.fromString(expectedResult);
    final opponentPlay = Play.fromString(opponentValue);

    switch (opponentPlay) {
      case Play.rock:
        switch (result) {
          case Result.win:
            return Play.paper;
          case Result.lose:
            return Play.sissors;
          case Result.draw:
            return Play.rock;
        }
      case Play.paper:
        switch (result) {
          case Result.win:
            return Play.sissors;
          case Result.lose:
            return Play.rock;
          case Result.draw:
            return Play.paper;
        }
      case Play.sissors:
        switch (result) {
          case Result.win:
            return Play.rock;
          case Result.lose:
            return Play.paper;
          case Result.draw:
            return Play.sissors;
        }
    }
  }

  const Play(this.inputValue);

  final String inputValue;

  int get playValue {
    switch (this) {
      case Play.rock:
        return 1;
      case Play.paper:
        return 2;
      case Play.sissors:
        return 3;
    }
  }

  Result winsFrom(Play other) {
    switch (this) {
      case Play.rock:
        switch (other) {
          case Play.rock:
            return Result.draw;
          case Play.paper:
            return Result.lose;
          case Play.sissors:
            return Result.win;
        }
      case Play.paper:
        switch (other) {
          case Play.rock:
            return Result.win;
          case Play.paper:
            return Result.draw;
          case Play.sissors:
            return Result.lose;
        }
      case Play.sissors:
        switch (other) {
          case Play.rock:
            return Result.lose;
          case Play.paper:
            return Result.win;
          case Play.sissors:
            return Result.draw;
        }
    }
  }
}

enum Result {
  win('Z'),
  lose('X'),
  draw('Y');

  const Result(this.inputValue);

  final String inputValue;

  factory Result.fromString(String value) {
    if (Result.win.inputValue == value) return Result.win;
    if (Result.lose.inputValue == value) return Result.lose;
    if (Result.draw.inputValue == value) return Result.draw;
    throw UnsupportedError('Invalid input for generating Result -> $value');
  }

  int get winValue {
    switch (this) {
      case Result.win:
        return 6;
      case Result.lose:
        return 0;
      case Result.draw:
        return 3;
    }
  }
}
