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
  final answer = Solver2a().solve(await input.readAsLines());

  print("My tournament score = $answer");
}

class Solver2a {
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
    String myValue,
    String opponentValue,
  )   : my = Play.fromString(myValue),
        opponent = Play.fromString(opponentValue);

  Result get result => my.winsFrom(opponent);

  int get score => result.winValue + my.playValue;
}

enum Play {
  rock(['A', 'X']),
  paper(['B', 'Y']),
  sissors(['C', 'Z']);

  factory Play.fromString(String value) {
    if (Play.rock.allowed.contains(value)) return Play.rock;
    if (Play.paper.allowed.contains(value)) return Play.paper;
    if (Play.sissors.allowed.contains(value)) return Play.sissors;
    throw 'Invalid input for generating play -> $value';
  }

  const Play(this.allowed);

  final List<String> allowed;

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
  win,
  lose,
  draw;

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
