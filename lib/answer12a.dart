import 'package:a_star/a_star.dart';
import 'package:aoc/solver.dart';

class Solver12a extends ISolver {
  @override
  String get key => '12a';

  @override
  String get question => 'What is the fewest steps required to move from your current'
      ' position to the location that should get the best signal?';

  late HeightMap _heightMap;

  @override
  int solve(List<String> input) {
    _heightMap = HeightMap.fromInput(input);

    _heightMap.findPath();

    return (_heightMap.path?.length ?? 0) - 1; // Path contains start
  }
}

class HeightMap {
  final int width;
  final List<Tile> tiles;
  final Tile start;
  final Tile end;

  List<Tile>? path;

  HeightMap(
    this.width,
    this.tiles,
    this.start,
    this.end,
  );

  static HeightMap fromInput(List<String> input) {
    final tiles = <Tile>[];
    Tile? start, end;
    int width = 0;

    for (int y = 0; y < input.length; y++) {
      final chars = input[y].split('');
      width = chars.length;
      for (int x = 0; x < width; x++) {
        final tile = Tile(x, y, chars[x]);
        if (tile.value == 'S') start = tile;
        if (tile.value == 'E') end = tile;

        tiles.add(tile);
      }
    }

    for (var i = 0; i < tiles.length; i++) {
      tiles[i].setConnectedTiles(tiles);
    }

    String row = '';
    for (var i = 0; i < tiles.length; i++) {
      if ((i > 0 && i % width == 0)) {
        print(row);
        row = '';
      }
      row += '${tiles[i].connectedTiles.length}';
    }
    print(row);

    return HeightMap(width, tiles, start!, end!);
  }

  void findPath() {
    final network = TileNetwork(tiles);
    final aStar = AStar(network);

    final aStarPath = aStar.findPathSync(start, end);

    path = aStarPath.toList();
  }
}

class TileNetwork extends Graph<Tile> {
  final List<Tile> tiles;

  TileNetwork(this.tiles);

  @override
  Iterable<Tile> get allNodes => tiles;

  @override
  num getDistance(Tile a, Tile b) => (b.height - a.height).abs() + 1;

  @override
  num getHeuristicDistance(Tile a, Tile b) => a.distanceTo(b);

  @override
  Iterable<Tile> getNeighboursOf(Tile node) => node.connectedTiles;
}

class Tile extends Object with Node<Tile> {
  final int x;
  final int y;
  final String value;
  final int height;

  final connectedTiles = <Tile>[];

  Tile(
    this.x,
    this.y,
    this.value,
  ) : height = _height(value);

  static int _height(String v) {
    if (v == 'S') return _letters.indexOf('a');
    if (v == 'E') return _letters.indexOf('z');
    return _letters.indexOf(v);
  }

  static final _letters = 'abcdefghijklmnopqrstuvwxyz';

  void setConnectedTiles(List<Tile> tiles) {
    // Empty existing connected tiles
    connectedTiles.clear();

    final tileAbove = _getValidConnectedTile(tiles, x, y - 1);
    if (tileAbove != null) connectedTiles.add(tileAbove);

    final tileLeft = _getValidConnectedTile(tiles, x - 1, y);
    if (tileLeft != null) connectedTiles.add(tileLeft);

    final tileDown = _getValidConnectedTile(tiles, x, y + 1);
    if (tileDown != null) connectedTiles.add(tileDown);

    final tileRight = _getValidConnectedTile(tiles, x + 1, y);
    if (tileRight != null) connectedTiles.add(tileRight);
  }

  Tile? _getValidConnectedTile(List<Tile> tiles, int x, int y) {
    final tile = tiles.cast<Tile?>().firstWhere(
          (tile) => tile?.x == x && tile?.y == y,
          orElse: () => null,
        );

    // It is connected (valid to move to)
    if (tile != null && (tile.height <= height + 1)) {
      return tile;
    }

    return null;
  }

  num distanceTo(Tile other) {
    final xOffset = (other.x - x).abs();
    final yOffset = (other.y - y).abs();
    final heightDiff = (other.height - height).abs();

    // The closer these 3 values are to 0 the closer we are to reaching the other
    return xOffset + yOffset + heightDiff;
  }
}
