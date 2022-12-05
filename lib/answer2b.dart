/*
For example, suppose you were given the following strategy guide:

A Y
B X
C Z
This strategy guide predicts and recommends the following:

In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.
In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

What would your total score be if everything goes exactly according to your strategy guide?
*/
import 'dart:io';

import 'package:file/local.dart';

Future<void> main() async {
  final input = LocalFileSystem().file('${Directory.current.path}/lib/input/input2.txt');
  final answer = Solver2b().solve(await input.readAsLines());

  print("My tournament score = $answer");
}

class Solver2b {
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
    throw 'Invalid input for generating play -> $value';
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
    if (other == this) return Result.draw;

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
    throw 'Invalid input for generating Result -> $value';
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
