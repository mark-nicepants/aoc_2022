import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

/// After simulating the rope, you can count up all of the positions the tail visited at least once.
/// In this diagram, s again marks the starting position (which the tail also visited) and # marks
///  other positions the tail visited:
///
/// ..##..
/// ...##.
/// .####.
/// ....#.
/// s###..
/// So, there are 13 positions the tail visited at least once.
///
/// Simulate your complete hypothetical series of motions.
/// How many positions does the tail of the rope visit at least once?
///
///
class Solver9a extends ISolver {
  @override
  String get key => '9a';

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
  var head = Position(0, 0);
  var tail = Position(0, 0);

  final tailHistory = [Position(0, 0)];

  int minX = 0;
  int maxX = 0;
  int minY = 0;
  int maxY = 0;

  int totalTailVisited() => tailHistory.length;

  void move(String instruction) {
    final direction = Direction.fromInput(instruction.split(' ')[0]);
    final moveCount = int.parse(instruction.split(' ')[1]);

    head = head.move(direction, moveCount);
    updateGridMinMax();

    while (!touching(head, tail)) {
      moveTailToHead();
    }
  }

  void updateGridMinMax() {
    minX = min(minX, head.x);
    maxX = max(maxX, head.x);
    minY = min(minY, head.y);
    maxY = max(maxY, head.y);
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

  String tailGraph({bool showHeadTail = false}) {
    var output = "";
    for (var y = maxY; y >= minY; y--) {
      for (var x = minX; x < maxX; x++) {
        final pos = tailHistory.cast<Position?>().firstWhere(
              (element) => element?.x == x && element?.y == y,
              orElse: () => null,
            );

        String append = '.';
        if (pos != null) append = '#';
        if (x == 0 && y == 0) append = 's';

        output += append;
      }

      output += "\n";
    }

    return output;
  }

  void moveTailToHead() {
    final xDelta = head.x - tail.x;
    final yDelta = head.y - tail.y;

    final direction = Direction.fromDelta(xDelta, yDelta);

    if (direction != null) {
      tail = tail.move(direction, tailMovementSpeed);
      if (!tailHistory.contains(tail)) {
        tailHistory.add(tail);
      }
    }
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
    if (x == 0 && y > 0) return Direction.up;
    if (x == 0 && y < 0) return Direction.down;

    // Straight horizontal movement
    if (y == 0 && x > 0) return Direction.right;
    if (y == 0 && x < 0) return Direction.left;

    // Diagonal moves
    if (x > 0 && y > 0) return Direction.upRight;
    if (x > 0 && y < 0) return Direction.downRight;
    if (x < 0 && y > 0) return Direction.upLeft;
    if (x < 0 && y < 0) return Direction.downLeft;

    return null; //Only case left => x=0 ,y=0; - no movement needed
  }
}
