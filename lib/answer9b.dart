import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

/// Rather than two knots, you now must simulate a rope consisting of ten knots.
/// One knot is still the head of the rope and moves according to the series of motions.
/// Each knot further down the rope follows the knot in front of it using the same rules as before.
///
/// Using the same series of motions as the above example, but with the knots marked H, 1, 2, ..., 9, the motions now occur as follows:
///
///
class Solver9b extends ISolver {
  @override
  String get key => '9b';

  @override
  String get question => 'How many positions does the tail of the rope visit at least once?';

  final grid = Grid();

  @override
  int solve(List<String> input) {
    for (var instruction in input) {
      grid.move(instruction);
    }

    return grid.totalTailVisited();
  }
}

const tailMovementSpeed = 1;
const ropeLength = 1;

class Grid {
  final knots = List.filled(10, Position(0, 0));

  // Tail starts here
  final tailHistory = [Position(0, 0)];

  int minX = 0;
  int maxX = 0;
  int minY = 0;
  int maxY = 0;

  int totalTailVisited() => tailHistory.length;

  Position get tail => knots[knots.length - 1];

  void move(String instruction) {
    final direction = Direction.fromInput(instruction.split(' ')[0]);
    final moveCount = int.parse(instruction.split(' ')[1]);

    // ignore: unused_local_variable
    for (final x in List.filled(moveCount, 0)) {
      knots[0] = knots[0].move(direction, 1);

      var previousKnot = knots[0];
      for (var i = 0; i < knots.length; i++) {
        while (!touching(previousKnot, knots[i])) {
          knots[i] = moveKnot(previousKnot, knots[i]);
        }
        previousKnot = knots[i];
      }
      updateGridMinMax();

      if (!tailHistory.contains(tail)) {
        tailHistory.add(tail);
      }
    }
  }

  void updateGridMinMax() {
    minX = min(minX, knots[0].x);
    maxX = max(maxX, knots[0].x);
    minY = min(minY, knots[0].y);
    maxY = max(maxY, knots[0].y);
  }

  bool touching(Position a, Position b) {
    int minX = a.x - ropeLength;
    int maxX = a.x + ropeLength;
    int minY = a.y - ropeLength;
    int maxY = a.y + ropeLength;

    bool xInRange = b.x >= minX && b.x <= maxX;
    bool yInRange = b.y >= minY && b.y <= maxY;

    return xInRange && yInRange;
  }

  String tailGraph() {
    var output = "";
    for (var y = maxY; y >= minY; y--) {
      for (var x = minX; x < maxX; x++) {
        final pos = knots.cast<Position?>().firstWhere(
              (element) => element?.x == x && element?.y == y,
              orElse: () => null,
            );

        String append = '.';
        if (pos != null) {
          final posIndex = knots.indexOf(pos);
          append = posIndex == 0 ? 'H' : '$posIndex';
        }

        output += append;
      }

      output += "\n";
    }

    return output;
  }

  Position moveKnot(Position head, Position tail) {
    final xDelta = head.x - tail.x;
    final yDelta = head.y - tail.y;

    final direction = Direction.fromDelta(xDelta, yDelta);

    if (direction != null) {
      return tail.move(direction, tailMovementSpeed);
    }
    return tail;
  }
}

class Position extends Equatable {
  final int x;
  final int y;

  Position(this.x, this.y);

  @override
  List<Object?> get props => [x, y];

  Position move(Direction direction, int moveCount) {
    int x = this.x;
    int y = this.y;

    switch (direction) {
      case Direction.left:
        x -= moveCount;
        break;
      case Direction.up:
        y += moveCount;
        break;
      case Direction.right:
        x += moveCount;
        break;
      case Direction.down:
        y -= moveCount;
        break;
      case Direction.upLeft:
        y += moveCount;
        x -= moveCount;
        break;
      case Direction.upRight:
        y += moveCount;
        x += moveCount;
        break;
      case Direction.downRight:
        y -= moveCount;
        x += moveCount;
        break;
      case Direction.downLeft:
        y -= moveCount;
        x -= moveCount;
        break;
    }

    return Position(x, y);
  }
}

enum Direction {
  left,
  upLeft,
  up,
  upRight,
  right,
  downRight,
  down,
  downLeft;

  static Direction fromInput(String input) {
    if (input == 'L') return Direction.left;
    if (input == 'U') return Direction.up;
    if (input == 'R') return Direction.right;
    if (input == 'D') return Direction.down;
    throw UnsupportedError('Invalid input for direction');
  }

  static Direction? fromDelta(int x, int y) {
    // Straight vertical movement
    if (x == 0) {
      if (y > 0) return Direction.up;
      if (y < 0) return Direction.down;
    }

    // Straight horizontal movement
    if (y == 0) {
      if (x > 0) return Direction.right;
      if (x < 0) return Direction.left;
    }

    // Diagonal moves
    if (x > 0 && y > 0) return Direction.upRight;
    if (x > 0 && y < 0) return Direction.downRight;
    if (x < 0 && y > 0) return Direction.upLeft;
    if (x < 0 && y < 0) return Direction.downLeft;

    return null; //Only case left => x=0 ,y=0; - no movement needed
  }
}
