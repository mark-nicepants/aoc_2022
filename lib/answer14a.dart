import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

class Solver14a extends ISolver {
  @override
  String get key => '141';

  @override
  String get question => 'Using your scan, simulate the falling sand.'
      'How many units of sand come to rest before sand starts flowing into the abyss below?';

  final cave = Cave();

  @override
  int solve(List<String> input) {
    cave.setWalls(input);

    return -1;
  }
}

class Cave {
  final points = <Point>[];

  int minX = -1;
  int maxX = -1;

  int minY = -1;
  int maxY = -1;

  void setWalls(List<String> input) {
    for (var row in input) {
      final coords = row.split(' -> ');
      for (var i = 0; i < points.length - 1; i++) {
        final start = Point.wallFromInput(coords[i]);
        final end = Point.wallFromInput(coords[i + 1]);

        Point p = start;
        while (p != end) {
          // Set min, when this hit sand will start falling of
          minX = minX == -1 ? p.x : min(minX, p.x);
          minY = minY == -1 ? p.y : min(minY, p.y);
          // Set maxes to be able to easily draw the grid
          maxX = maxX == -1 ? p.x : max(maxX, p.x);
          maxY = maxY == -1 ? p.y : max(maxY, p.y);

          points.add(p);
          p = p.moveTo(end);
        }
      }
    }
  }

  List<String> map(bool filled) {
    if (!filled) {
      return [];
    } else {
      return [];
    }
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
}

enum PointType { wall, sand }
