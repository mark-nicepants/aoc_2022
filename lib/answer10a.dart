import 'package:aoc/solver.dart';

/// Find the signal strength during the
/// 20th, 60th, 100th, 140th, 180th, and 220th cycles.
///
/// What is the sum of these six signal strengths?
///
class Solver10a extends ISolver {
  @override
  String get key => '10a';

  @override
  String get question => 'What is the sum of these six signal strengths?';

  final cpu = CPU();

  @override
  int solve(List<String> input) {
    final parts = <int>[];
    final cyclesToCheck = [20, 60, 100, 140, 180, 220];
    cpu.execute(
      input.map(Operation.fromInput).toList(),
      (cycle, register) {
        if (cyclesToCheck.contains(cycle)) {
          parts.add(cycle * register);
        }
      },
    );

    return parts.reduce((value, element) => value + element);
  }
}

class CPU {
  int cycle = 1;
  int register = 1;

  void execute(
    List<Operation> operations, [
    void Function(int cycle, int register)? cycleExecutedCallback,
  ]) {
    void broadcastEndOfCycle() {
      cycleExecutedCallback?.call(cycle, register);
      cycle++;
    }

    for (var operation in operations) {
      final waitCycles = operation.cyclesToComplete - 1;

      for (var i = 0; i < waitCycles; i++) {
        broadcastEndOfCycle();
      }

      // Do register operation
      broadcastEndOfCycle();
      register += operation.registerValue;
    }
  }

  void reset() {
    cycle = 1;
    register = 1;
  }
}

class Operation {
  final int cyclesToComplete;
  final int registerValue;

  static Operation fromInput(String input) {
    if (input == 'noop') return Operation.noop();
    if (input.startsWith('addx')) return Operation.addx(int.parse(input.split(' ')[1]));
    throw UnsupportedError('Invalid input for Operation given ($input)');
  }

  factory Operation.noop() => Operation(1, 0);

  factory Operation.addx(int registerValue) => Operation(2, registerValue);

  Operation(this.cyclesToComplete, this.registerValue);
}
