import 'package:aoc/solver.dart';

/// 30373
/// 25512
/// 65332
/// 33549
/// 35390
///
/// Looking up, its view is blocked at 2 trees (by another tree with a height of 5).
/// Looking left, its view is not blocked; it can see 2 trees.
/// Looking down, its view is also not blocked; it can see 1 tree.
/// Looking right, its view is blocked at 2 trees (by a massive tree of height 9).
///
/// This tree's scenic score is 8 (2 * 2 * 1 * 2); this is the ideal spot for the tree house.

class Solver8b extends ISolver {
  @override
  String get key => '8b';

  @override
  String get question => 'What is the highest scenic score possible for any tree?';

  Grid? grid;

  @override
  int solve(List<String> input) {
    grid = Grid(input);

    // Sort by scenic score
    grid?.trees.sort((a, b) => b.scenicScore.compareTo(a.scenicScore));

    // return best scorer
    return grid?.trees[0].scenicScore ?? 0;
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

    int numCols = 0;
    for (var y = 0; y < input.length; y++) {
      final cols = input[y].split('');
      numCols = cols.length;

      for (var x = 0; x < numCols; x++) {
        final char = cols[x];

        bool sameRow(Tree e) => e.y == y;
        bool sameCol(Tree e) => e.x == x;

        final toLeft = output.where(sameRow).toList();
        final toTop = output.where(sameCol).toList();

        final tree = Tree(x, y, int.parse(char));
        _checkLeftScenicScore(tree, toLeft.reversed.toList());
        _checkTopScenicScore(tree, toTop.reversed.toList());

        output.add(tree);
      }

      // Row is done! Re-iterate this row and calculate all right scenic scores
      final row = output.where((element) => element.y == y).toList();
      for (var tree in row) {
        final treesToRight = row.sublist(tree.x + 1);
        final indexOfBlockingtree = treesToRight.indexWhere((element) => element.value >= tree.value);

        if (indexOfBlockingtree == -1) {
          tree.rightScenicScore = treesToRight.length;
        } else {
          tree.rightScenicScore = indexOfBlockingtree + 1;
        }
      }
    }

    // All rows are done, re-iterate cols to calculate all bottom scenic scores
    for (var x = 0; x < numCols; x++) {
      final col = output.where((element) => element.x == x).toList();
      for (var tree in col) {
        final treesBelow = col.sublist(tree.y + 1);
        final indexOfBlockingtree = treesBelow.indexWhere((element) => element.value >= tree.value);
        if (indexOfBlockingtree == -1) {
          tree.bottomScenicScore = treesBelow.length;
        } else {
          tree.bottomScenicScore = indexOfBlockingtree + 1;
        }
      }
    }

    return output;
  }

  static void _checkLeftScenicScore(Tree tree, List<Tree> toLeft) {
    for (var i = 0; i < toLeft.length; i++) {
      if (toLeft[i].value >= tree.value) {
        tree.leftScenicScore = i + 1;
        break;
      }
    }

    // No tree between me or the edge
    if (tree.leftScenicScore == 0) {
      tree.leftScenicScore = tree.x;
    }
  }

  static void _checkTopScenicScore(Tree tree, List<Tree> toTop) {
    for (var i = 0; i < toTop.length; i++) {
      if (toTop[i].value >= tree.value) {
        tree.topScenicScore = i + 1;
        break;
      }
    }

    // No tree between me or the edge
    if (tree.topScenicScore == 0) {
      tree.topScenicScore = tree.y;
    }
  }
}

class Tree {
  final int value;
  final int x;
  final int y;

  int leftScenicScore = 0;
  int topScenicScore = 0;
  int rightScenicScore = 0;
  int bottomScenicScore = 0;

  int get scenicScore => leftScenicScore * topScenicScore * rightScenicScore * bottomScenicScore;

  Tree(this.x, this.y, this.value);
}
