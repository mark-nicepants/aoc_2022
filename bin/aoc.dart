import 'package:aoc/answer10a.dart';
import 'package:aoc/answer10b.dart';
import 'package:aoc/answer11a.dart';
import 'package:aoc/answer11b.dart';
import 'package:aoc/answer1a.dart';
import 'package:aoc/answer1b.dart';
import 'package:aoc/answer2a.dart';
import 'package:aoc/answer2b.dart';
import 'package:aoc/answer3a.dart';
import 'package:aoc/answer3b.dart';
import 'package:aoc/answer4a.dart';
import 'package:aoc/answer4b.dart';
import 'package:aoc/answer5a.dart';
import 'package:aoc/answer5b.dart';
import 'package:aoc/answer6a.dart';
import 'package:aoc/answer6b.dart';
import 'package:aoc/answer7a.dart';
import 'package:aoc/answer7b.dart';
import 'package:aoc/answer8a.dart';
import 'package:aoc/answer8b.dart';
import 'package:aoc/answer9a.dart';
import 'package:aoc/answer9b.dart';
import 'package:args/args.dart';
import 'package:file/local.dart';
import 'dart:io' as io;

Future<void> main(List<String> args) async {
  final parser = ArgParser();

  parser.addSeparator('===== Advent of Code 2022 CLI ==== \n');
  parser.addOption(
    'answer',
    mandatory: true,
    abbr: 'a',
    allowed: _solvers.map((e) => e.key),
    allowedHelp: _solvers.asMap().map((k, v) => MapEntry(v.key, v.question)),
    help: 'Choose a solver print out a answer',
  );

  try {
    final results = parser.parse(args);

    final solverKey = results['answer'] as String;
    final index = solverKey.replaceAll('a', '').replaceAll('b', '');
    final input = LocalFileSystem().file('${io.Directory.current.path}/lib/input/input$index.txt');

    print(_solvers.firstWhere((element) => element.key == solverKey).printSolve(await input.readAsLines()));
  } catch (e) {
    print(parser.usage);
  }
}

final _solvers = [
  Solver1a(),
  Solver1b(),
  Solver2a(),
  Solver2b(),
  Solver3a(),
  Solver3b(),
  Solver4a(),
  Solver4b(),
  Solver5a(_puzzleStart5),
  Solver5b(_puzzleStart5),
  Solver6a(),
  Solver6b(),
  Solver7a(),
  Solver7b(),
  Solver8a(),
  Solver8b(),
  Solver9a(),
  Solver9b(),
  Solver10a(),
  Solver10b(),
  Solver11a(),
  Solver11b(),
];

final _puzzleStart5 = [
  "        [G]         [D]     [Q]    ",
  "[P]     [T]         [L] [M] [Z]    ",
  "[Z] [Z] [C]         [Z] [G] [W]    ",
  "[M] [B] [F]         [P] [C] [H] [N]",
  "[T] [S] [R]     [H] [W] [R] [L] [W]",
  "[R] [T] [Q] [Z] [R] [S] [Z] [F] [P]",
  "[C] [N] [H] [R] [N] [H] [D] [J] [Q]",
  "[N] [D] [M] [G] [Z] [F] [W] [S] [S]",
  " 1   2   3   4   5   6   7   8   9 ",
];
