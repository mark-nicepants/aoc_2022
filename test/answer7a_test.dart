import 'package:aoc/answer7a.dart';
import 'package:test/test.dart';

void main() {
  test('7a', () {
    final solver = Solver7a();

    expect(solver.key, equals('7a'));
    expect(solver.question, startsWith('Find all of the directories with a'));

    final answer = solver.solve(input);

    expect(solver.fileSystem?.toString(), equals(output));
    expect(answer, equals(95437));

    solver.fileSystem?.cd('invalid');
    expect(solver.fileSystem?.currentDir, isNull);

    expect(() => Instruction.fromInput(['\$ pwd'], 0), throwsA(TypeMatcher<UnsupportedError>()));
  });
}

final input = [
  "\$ cd /",
  "\$ ls",
  "dir a",
  "14848514 b.txt",
  "8504156 c.dat",
  "dir d",
  "\$ cd a",
  "\$ ls",
  "dir e",
  "29116 f",
  "2557 g",
  "62596 h.lst",
  "\$ cd e",
  "\$ ls",
  "584 i",
  "\$ cd ..",
  "\$ cd ..",
  "\$ cd d",
  "\$ ls",
  "4060174 j",
  "8033020 d.log",
  "5626152 d.ext",
  "7214296 k",
];

final output = "- / (dir)\n"
    "  - a (dir)\n"
    "    - e (dir)\n"
    "      - i (file, size=584)\n"
    "    - f (file, size=29116)\n"
    "    - g (file, size=2557)\n"
    "    - h.lst (file, size=62596)\n"
    "  - b.txt (file, size=14848514)\n"
    "  - c.dat (file, size=8504156)\n"
    "  - d (dir)\n"
    "    - j (file, size=4060174)\n"
    "    - d.log (file, size=8033020)\n"
    "    - d.ext (file, size=5626152)\n"
    "    - k (file, size=7214296)";
