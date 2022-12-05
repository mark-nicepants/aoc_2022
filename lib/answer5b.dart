import 'package:aoc/solver.dart';

/// Before the rearrangement process finishes, update your simulation so that the
/// Elves know where they should stand to be ready to unload the final supplies.
///
/// After the rearrangement procedure completes, what crate ends up on top of each stack

class Solver5b extends ISolver {
  @override
  String get key => '5b';

  @override
  String get question => 'After the rearrangement procedure completes, what crate ends up on top of each stack?';

  final Platform platform;

  Solver5b(List<String> puzzle) : platform = Platform.fromInput(4, puzzle);

  @override
  String solve(List<String> input) {
    platform.handleInstructions(input.map(Instruction.fromInput).toList());

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
    return "$index: ${crates.map((e) => "[$e]").join(" ")}";
  }

  List<String> grab(int numCrates) {
    final grabbed = <String>[];
    for (int i = 0; i < numCrates; i++) {
      grabbed.add(crates.removeLast());
    }
    return grabbed.reversed.toList(); // Grab em in order
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
