import 'dart:math';

import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';

class Solver15a extends ISolver {
  Solver15a(this.rowIndex);

  @override
  String get key => '15a';

  @override
  String get question => 'Consult the report from the sensors you just deployed.'
      ' In the row where y=2000000, how many positions cannot contain a beacon?';

  final int rowIndex;

  @override
  int solve(List<String> input) {
    final grid = Grid();
    final sensors = <Sensor>[];

    parseInput(input, sensors, grid);

    return grid.unavailableSpaces(rowIndex, sensors);
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

  int unavailableSpaces(int y, List<Sensor> sensors) {
    int output = 0;

    bool occupied(int x) {
      // Check if point is beacon or sensor
      if (hasPoint(x, y)) return false;

      for (final sensor in sensors) {
        if (sensor.inRange(x, y)) {
          return true;
        }
      }

      return false;
    }

    loopY(y, (x) {
      output += occupied(x) ? 1 : 0;
    });

    return output;
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
