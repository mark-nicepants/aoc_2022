import 'package:aoc/answer5b.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('5b After the rearrangement procedure completes, what crate ends up on top of each stack?', () {
    final platform = Platform.fromInput(4, input);

    // Query per row
    expect(platform.row(0), equals('ZMP'));
    expect(platform.row(1), equals('NC '));
    expect(platform.row(2), equals(' D '));

    // Top stack
    expect(platform.topStack(), equals('NDP'));

    final parsedInstructions = instructions.map(Instruction.fromInput).toList();
    expect(parsedInstructions[0].toString(), equals('move 1 from 2 to 1'));
    expect(parsedInstructions[1].toString(), equals('move 3 from 1 to 3'));

    platform.handleInstruction(parsedInstructions[0]);
    expect(platform.topStack(), equals('DCP'));

    platform.handleInstruction(parsedInstructions[1]);
    expect(platform.topStack(), equals(' CD'));

    platform.handleInstruction(parsedInstructions[2]);
    expect(platform.topStack(), equals('C D'));

    platform.handleInstruction(parsedInstructions[3]);
    expect(platform.topStack(), equals('MCD'));

    final solver = Solver5b();
    expect(solver.solve(input, instructions), equals("MCD"));
  });
}

final input = [
  "    [D]    ",
  "[N] [C]    ",
  "[Z] [M] [P]",
  " 1   2   3 ",
];

final instructions = [
  "move 1 from 2 to 1",
  "move 3 from 1 to 3",
  "move 2 from 2 to 1",
  "move 1 from 1 to 2",
];
