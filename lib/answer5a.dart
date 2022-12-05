import 'dart:io';

import 'package:file/local.dart';

final puzzleStart = [
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

Future<void> main() async {
  final input = LocalFileSystem().file('${Directory.current.path}/lib/input/input5.txt');
  final answer = Solver5a().solve(puzzleStart, await input.readAsLines());

  print("After the rearrangement procedure completes, what crate ends up on top of each stack?? Answer: $answer");
}

class Solver5a {
  String solve(List<String> puzzle, List<String> instructions) {
    final platform = Platform.fromInput(4, puzzle);

    platform.handleInstructions(instructions.map(Instruction.fromInput).toList());

    return platform.topStack();
  }
}

class Platform {
  final List<Stack> stacks;

  Platform(this.stacks);

  factory Platform.fromInput(int charsPerStack, List<String> input) {
    final numStacks = (input[0].length / charsPerStack).ceil();
    final stacks = List.generate(numStacks, Stack.new);

    for (var element in input.reversed) {
      final matches = RegExp(r'\[(.)\]').allMatches(element);

      for (var element in matches) {
        final stackIndex = element.start ~/ charsPerStack;
        stacks[stackIndex].add(element.group(1)!);
      }
    }

    return Platform(stacks);
  }

  String row(int rowFromBottom) {
    return stacks.map((e) => e.crates.length <= rowFromBottom ? ' ' : e.crates[rowFromBottom]).join('');
  }

  String topStack() {
    return stacks.map((e) => e.crates.isEmpty ? ' ' : e.crates[e.crates.length - 1]).join('');
  }

  @override
  String toString() {
    return stacks.map((e) => e.toString()).join('\n');
  }

  void handleInstructions(List<Instruction> instructions) {
    instructions.forEach(handleInstruction);
  }

  void handleInstruction(Instruction instruction) {
    final cratesToMove = stacks[instruction.fromStackIndex - 1].grab(instruction.numCratesToMove);
    stacks[instruction.toStackIndex - 1].put(cratesToMove);
  }
}

class Stack {
  final int index;
  final crates = <String>[];

  // Stack indexes are 1 based
  Stack(int index) : index = index + 1;

  void add(String crate) {
    crates.add(crate);
  }

  @override
  String toString() {
    return " $index\t${crates.map((e) => "[$e]").join(" ")}";
  }

  List<String> grab(int numCrates) {
    final grabbed = <String>[];
    for (int i = 0; i < numCrates; i++) {
      grabbed.add(crates.removeLast());
    }
    return grabbed;
  }

  void put(List<String> newCrates) {
    crates.addAll(newCrates);
  }
}

class Instruction {
  final int numCratesToMove;
  final int fromStackIndex;
  final int toStackIndex;

  Instruction({
    required this.numCratesToMove,
    required this.fromStackIndex,
    required this.toStackIndex,
  });

  factory Instruction.fromInput(String input) {
    final matches = RegExp(r'(\d+)').allMatches(input).toList();

    return Instruction(
      numCratesToMove: int.parse(matches[0].group(1)!),
      fromStackIndex: int.parse(matches[1].group(1)!),
      toStackIndex: int.parse(matches[2].group(1)!),
    );
  }

  @override
  String toString() {
    return 'move $numCratesToMove from $fromStackIndex to $toStackIndex';
  }
}
