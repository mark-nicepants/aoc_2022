import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

class Solver14b extends ISolver {
  @override
  String get key => '14b';

  @override
  String get question => 'Using your scan, simulate the falling sand '
      'until the source of the sand becomes blocked. How many units of sand come to rest?';

  final cave = Cave();

  @override
  int solve(List<String> input) {
    cave.setWalls(input);

    while (!cave.sandReachedStartLocation) {
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

  int bottomY = 0;

  int get unitsDropped {
    final units = points.where((element) => element.type == PointType.sand).length;
    return sandReachedStartLocation ? units + 1 : units;
  }

  bool sandReachedStartLocation = false;

  late final sandPourLocation = Point(500, 0, PointType.sandPour);

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

          updateMinMax(p);
          points.add(p);
        } while (p != end);
      }
    }

    bottomY = maxY + 2;
  }

  void updateMinMax(Point p) {
    // Set min, when this hit sand will start falling of
    minX = min(minX, p.x);
    minY = min(minY, p.y);
    // Set maxes to be able to easily draw the grid
    maxX = max(maxX, p.x);
    maxY = max(maxY, p.y);
  }

  List<String> map(bool filled) {
    return List.generate(bottomY - minY + 1, (yIndex) {
      return List.generate(maxX - minX + 1, (xIndex) {
        final x = xIndex + minX;
        final y = yIndex + minY;

        if (y == bottomY) {
          return PointType.wall.toString();
        }

        final p = points.firstWhere(
          (p) => p.x == x && p.y == y,
          orElse: () => Point(x, y, PointType.empty),
        );

        if (sandReachedStartLocation && x == sandPourLocation.x && y == sandPourLocation.y) {
          return 'o';
        }

        return p.type.toString();
      }).join('');
    });
  }

  void dropSandUnit() {
    final idleLocation = fall(sandPourLocation);
    updateMinMax(idleLocation);

    // Top reached, sand will stop
    if (idleLocation.x == sandPourLocation.x && idleLocation.y == sandPourLocation.y) {
      sandReachedStartLocation = true;
    } else {
      points.insert(0, idleLocation);
    }
  }

  Point fall(Point sand) {
    final obstacle = firstObstacleBelow(sand);

    final left = getPoint(obstacle.x - 1, obstacle.y);
    if (left == null) return fall(obstacle.copyAsSand(xOffset: -1));

    final right = getPoint(obstacle.x + 1, obstacle.y);
    if (right == null) return fall(obstacle.copyAsSand(xOffset: 1));

    // Land on top of found obstacle when left and right are not an option
    return obstacle.copyAsSand(yOffset: -1);
  }

  Point? getPoint(int x, int y) {
    // The floor is lava
    if (y >= bottomY) {
      return Point(x, y, PointType.wall);
    }

    return points.cast<Point?>().firstWhere((p) => p?.x == x && p?.y == y, orElse: () => null);
  }

  Point firstObstacleBelow(Point other) {
    final belowMe = points
        .where((p) => p.x == other.x && p.y > other.y)
        .where((element) => element.type != PointType.empty)
        .toList();

    if (belowMe.isEmpty) return Point(other.x, bottomY, PointType.wall);

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
