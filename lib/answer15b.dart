import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

class Solver15b extends ISolver {
  Solver15b(this.min, this.max);

  @override
  String get key => '15b';

  @override
  String get question => 'Find the only possible position for the distress beacon.'
      'What is its tuning frequency?';

  final int min;
  final int max;

  @override
  int solve(List<String> input) {
    final grid = Grid();
    final sensors = <Sensor>[];

    parseInput(input, sensors, grid);

    final point = grid.checkPerimiter(sensors, min, max);
    print(point);

    if (point == null) {
      return -1;
    } else {
      return (4000000 * point.x) + point.y;
    }
  }

  void parseInput(List<String> input, List<Sensor> sensors, Grid grid) {
    for (var row in input) {
      final parts = row.split(':');

      final xS = _get('x=', parts[0]);
      final yS = _get('y=', parts[0]);
      final xB = _get('x=', parts[1]);
      final yB = _get('y=', parts[1]);

      final beacon = Point(xB, yB);
      final sensor = Sensor(xS, yS, beacon);

      sensors.add(sensor);

      grid.addPoint(sensor);
      grid.addPoint(beacon);
    }
  }
}

class Grid {
  int? _minX;
  int? _maxX;
  int? _minY;
  int? _maxY;

  int get minX => _minX!;
  int get maxX => _maxX!;
  int get minY => _minY!;
  int get maxY => _maxY!;

  int get width => maxX - minX;
  int get height => maxY - minY;

  final points = <int, Map<int, Point>>{};

  void addPoint(Point p) {
    _minX = _minX == null ? p.minX : min(p.minX, _minX!);
    _maxX = _maxX == null ? p.maxX : max(p.maxY, _maxX!);
    _minY = _minY == null ? p.minY : min(p.minY, _minY!);
    _maxY = _maxY == null ? p.maxY : max(p.maxY, _maxY!);

    if (!points.containsKey(p.x)) {
      points[p.x] = <int, Point>{};
    }

    points[p.x]?[p.y] = p;
  }

  void loop(void Function(int x, int y) loop) {
    for (var y = minY; y < maxY; y++) {
      loopY(y, (x) => loop(x, y));
    }
  }

  void loopY(int y, void Function(int x) loop) {
    for (var x = minX; x < maxX; x++) {
      loop(x);
    }
  }

  bool hasPoint(int x, int y) {
    return points[x]?[y] != null;
  }

  Point? getPoint(int x, int y) {
    return points[x]?[y];
  }

  int rowIndex(int y) => minY.abs() + y + 1;

  List<String> coverage(List<Sensor> sensors) {
    final coverage = <String>[];
    String row = "";
    int lastY = 0;
    loop((x, y) {
      if (lastY != y) {
        coverage.add(row);
        lastY = y;
        row = '';
      }

      row += _checkCell(sensors, x, y);
    });

    coverage.add(row);

    return coverage;
  }

  String coverageForRow(int y, List<Sensor> sensors) {
    String row = "";
    loopY(y, (x) {
      row += _checkCell(sensors, x, y);
    });

    return row;
  }

  Point? checkPerimiter(List<Sensor> sensors, int min, int max) {
    for (int i = 0; i < sensors.length; i++) {
      var sensor = sensors[i];
      final stopwatch = Stopwatch()..start();

      print('Sensor $i walk edges');
      final result = sensor.walkEdges((x, y) {
        final validX = x > min && x < max;
        final validY = y > min && y < max;

        if (!validX || !validY) {
          return false;
        }

        // When true this will break the walk edges and return this x,y as a result
        return _cellEmpty(sensors, x, y);
      });

      if (result != null) {
        print("Result found! $result");
        return result;
      }

      print('Sensor $sensor checked ($i/${sensors.length}) ${stopwatch.elapsed}');
    }

    return null;
  }

  bool _cellEmpty(List<Sensor> sensors, int x, int y) {
    if (hasPoint(x, y)) {
      return false;
    }

    // Check if point is beacon or sensor
    for (final sensor in sensors) {
      if (sensor.inRange(x, y)) {
        return false;
      }
    }

    return true;
  }

  String _checkCell(List<Sensor> sensors, int x, int y) {
    if (hasPoint(x, y)) {
      final p = getPoint(x, y);
      if (p is Sensor) {
        return '${p.distance}';
      } else {
        return 'B';
      }
    }

    // Check if point is beacon or sensor
    for (final sensor in sensors) {
      if (sensor.inRange(x, y)) {
        return '#';
      }
    }

    return ".";
  }
}

class Point extends Equatable {
  final int x;
  final int y;

  Point(this.x, this.y);

  int distanceTo(int otherX, int otherY) {
    return (x - otherX).abs() + (y - otherY).abs();
  }

  @override
  List<Object?> get props => [x, y];

  int get minX => x;
  int get maxX => x;
  int get minY => y;
  int get maxY => y;
}

class Sensor extends Point {
  final int distance;

  Sensor(
    super.x,
    super.y,
    Point closest,
  ) : distance = closest.distanceTo(x, y);

  bool inRange(int x, int y) {
    return distanceTo(x, y) <= distance;
  }

  Point? walkEdges(bool Function(int x, int y) callback) {
    // Add all edges just outside of our reach given distance to beacon
    for (int xOffset = 0; xOffset <= distance + 1; xOffset++) {
      final yOffset = (distance + 1) - xOffset;

      bool breakLoop = false;

      breakLoop = callback(x - xOffset, y + yOffset);
      if (breakLoop) return Point(x - xOffset, y + yOffset);

      breakLoop = callback(x + xOffset, y + yOffset);
      if (breakLoop) return Point(x + xOffset, y + yOffset);

      breakLoop = callback(x - xOffset, y - yOffset);
      if (breakLoop) return Point(x - xOffset, y - yOffset);

      breakLoop = callback(x + xOffset, y - yOffset);
      if (breakLoop) return Point(x + xOffset, y - yOffset);
    }

    return null;
  }

  @override
  String toString() {
    return "Sensor $x, $y => $distance";
  }

  @override
  int get minX => x - distance;

  @override
  int get maxX => x + distance;

  @override
  int get minY => y - distance;

  @override
  int get maxY => y + distance;
}

int _get(String prefix, String input) {
  int start = input.indexOf(prefix) + 2;
  int end = input.indexOf(',');

  if (end < start) end = input.length;

  return int.parse(input.substring(start, end));
}
