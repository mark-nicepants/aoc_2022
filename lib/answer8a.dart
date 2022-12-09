import 'package:aoc/solver.dart';

/// The expedition comes across a peculiar patch of tall trees all planted carefully
/// in a grid. The Elves explain that a previous expedition planted these trees as a
/// reforestation effort. Now, they're curious if this would be a good location for a
///  tree house.
///
/// First, determine whether there is enough tree cover here to keep a tree house hidden.
///  To do this, you need to count the number of trees that are visible from outside the
///  grid when looking directly along a row or column.
///
/// The Elves have already launched a quadcopter to generate a map with the height
///  of each tree (your puzzle input).

class Solver8a extends ISolver {
  @override
  String get key => '8a';

  @override
  String get question => 'Consider your map; how many trees are visible from outside the grid?';

  Grid? grid;

  @override
  int solve(List<String> input) {
    grid = Grid(input);

    return grid?.visibleTreesFromOutside() ?? 0;
  }
}

enum Side { top, left, bottom, right }

class Grid {
  final List<Tree> trees;

  Grid(List<String> input) : trees = _parse(input);

  Tree coord(int x, int y) {
    return trees.firstWhere((element) => element.x == x && element.y == y);
  }

  static List<Tree> _parse(List<String> input) {
    final output = <Tree>[];

    for (var y = 0; y < input.length; y++) {
      final row = input[y];
      final cols = row.split('');

      for (var x = 0; x < cols.length; x++) {
        final char = cols[x];

        bool sameRow(Tree e) => e.y == y;
        bool sameCol(Tree e) => e.x == x;

        final toLeft = output.where(sameRow).toList();
        final toTop = output.where(sameCol).toList();

        final tree = Tree(x, y, int.parse(char));
        _checkLeftVisibility(tree, toLeft);
        _checkTopVisibility(tree, toTop);

        output.where(sameRow).where((tree) => tree.visibility.contains(Side.right)).forEach(
          (other) {
            if (tree.value >= other.value) {
              other.visibility.remove(Side.right);
            }
          },
        );

        output.where(sameCol).where((tree) => tree.visibility.contains(Side.bottom)).forEach(
          (other) {
            if (tree.value >= other.value) {
              other.visibility.remove(Side.bottom);
            }
          },
        );
        output.add(tree);
      }
    }
    return output;
  }

  static void _checkLeftVisibility(Tree tree, List<Tree> toLeft) {
    final visible = toLeft.indexWhere((element) => element.value >= tree.value) == -1;

    if (visible) {
      tree.visibility.add(Side.left);
    }
  }

  static void _checkTopVisibility(Tree tree, List<Tree> toTop) {
    final visible = toTop.indexWhere((element) => element.value >= tree.value) == -1;

    if (visible) {
      tree.visibility.add(Side.top);
    }
  }

  int visibleTreesFromOutside() {
    return trees.where((e) => e.visibility.isNotEmpty).length;
  }
}

class Tree {
  final int value;
  final int x;
  final int y;

  // Top and left will be added if visible
  // Bottom and right are given and removed when blocked later
  final visibility = <Side>[
    Side.right,
    Side.bottom,
  ];

  Tree(this.x, this.y, this.value);
}
