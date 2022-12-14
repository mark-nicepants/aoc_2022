import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

class Solver14a extends ISolver {
  @override
  String get key => '14a';

  @override
  String get question => 'Using your scan, simulate the falling sand.'
      'How many units of sand come to rest before sand starts flowing into the abyss below?';

  final cave = Cave();

  @override
  int solve(List<String> input) {
    cave.reset();
    cave.setWalls(input);

    while (!cave.sandReachedVoid) {
      cave.dropSandUnit();
    }

    return cave.unitsDropped;
  }
}

class Cave {
  late final points = <Point>[sandPourLocation];

  int minX = 500;
  int maxX = 500;

  int minY = 0;
  int maxY = 0;

  int unitsDropped = 0;
  bool sandReachedVoid = false;

  late final sandPourLocation = Point(500, 0, PointType.sandPour);

  void reset() {
    minX = 500;
    maxX = 500;

    minY = 0;
    maxY = 0;

    unitsDropped = 0;
    sandReachedVoid = false;

    points.clear();
    points.add(sandPourLocation);
  }

  void setWalls(List<String> input) {
    for (var row in input) {
      final coords = row.split(' -> ');
      for (var i = 0; i < coords.length - 1; i++) {
        final start = Point.wallFromInput(coords[i]);
        final end = Point.wallFromInput(coords[i + 1]);

        Point p = start;
        bool first = true;
        do {
          if (!first) {
            p = p.moveTo(end);
          }

          first = false;

          // Set min, when this hit sand will start falling of
          minX = min(minX, p.x);
          minY = min(minY, p.y);
          // Set maxes to be able to easily draw the grid
          maxX = max(maxX, p.x);
          maxY = max(maxY, p.y);

          points.add(p);
        } while (p != end);
      }
    }
  }

  List<String> map(bool filled) {
    return List.generate(maxY - minY + 1, (yIndex) {
      return List.generate(maxX - minX + 1, (xIndex) {
        final x = xIndex + minX;
        final y = yIndex + minY;

        final p = points.firstWhere(
          (p) => p.x == x && p.y == y,
          orElse: () => Point(x, y, PointType.empty),
        );

        if (!filled && p.type == PointType.sand) {
          return '.';
        } else {
          return p.type.toString();
        }
      }).join('');
    });
  }

  void dropSandUnit([bool debug = false]) {
    final idleLocation = fall(sandPourLocation, debug);

    // No wall, end here
    if (idleLocation == null) {
      sandReachedVoid = true;
    } else {
      unitsDropped++;
      points.insert(0, idleLocation);
    }
  }

  Point? fall(Point sand, [bool debug = false]) {
    if (debug) print('fall $sand');
    final obstacle = firstObstacleBelow(sand);
    if (debug) print('obstacle $obstacle');
    if (obstacle == null) return null;

    final left = getPoint(obstacle.x - 1, obstacle.y);
    if (debug) print('left $left = ${obstacle.x - 1} - ${obstacle.y}');
    if (left == null) return fall(obstacle.copyAsSand(xOffset: -1), debug);

    final right = getPoint(obstacle.x + 1, obstacle.y);
    if (debug) print('right $right = ${obstacle.x + 1} - ${obstacle.y}');
    if (right == null) return fall(obstacle.copyAsSand(xOffset: 1), debug);

    // Land on top of found obstacle when left and right are not an option
    return obstacle.copyAsSand(yOffset: -1);
  }

  Point? getPoint(int x, int y) {
    return points.cast<Point?>().firstWhere((p) => p?.x == x && p?.y == y, orElse: () => null);
  }

  Point? firstObstacleBelow(Point other) {
    final belowMe = points
        .where((p) => p.x == other.x && p.y > other.y)
        .where((element) => element.type != PointType.empty)
        .toList();

    if (belowMe.isEmpty) return null;

    belowMe.sort((l, r) => l.y.compareTo(r.y));

    return belowMe.first;
  }
}

class Point extends Equatable {
  final int x;
  final int y;
  final PointType type;

  Point(this.x, this.y, this.type);

  factory Point.wallFromInput(String input) => Point(
        int.parse(input.split(',')[0]),
        int.parse(input.split(',')[1]),
        PointType.wall,
      );

  Point moveTo(Point other) {
    if (x == other.x) {
      if (y > other.y) {
        return Point(x, y - 1, type);
      } else {
        return Point(x, y + 1, type);
      }
    }

    if (y == other.y) {
      if (x > other.x) {
        return Point(x - 1, y, type);
      } else {
        return Point(x + 1, y, type);
      }
    }

    throw UnsupportedError('Points need to be either on the same X of the same Y to move to eachother');
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() {
    return '$x, $y => $type';
  }

  Point copyAsSand({int xOffset = 0, int yOffset = 0}) {
    return Point(x + xOffset, y + yOffset, PointType.sand);
  }
}

enum PointType {
  wall,
  sand,
  sandPour,
  empty;

  @override
  String toString() {
    switch (this) {
      case PointType.wall:
        return '#';
      case PointType.sand:
        return 'o';
      case PointType.sandPour:
        return '+';
      case PointType.empty:
        return '.';
    }
  }
}
