import 'package:aoc/answer7b.dart';
import 'package:test/test.dart';

void main() {
  test('7b', () {
    final solver = Solver7b();

    expect(solver.key, equals('7b'));
    expect(solver.question, startsWith('What is the total size of that directory?'));

    final answer = solver.solve(input);

    expect(21618835, equals(solver.fileSystem?.spaceLeft));
    expect(answer, equals(24933642));

    solver.fileSystem?.cd('invalid');
    expect(solver.fileSystem?.currentDir, isNull);

    expect(() => Instruction.fromInput(['\$ pwd'], 0), throwsA(TypeMatcher<UnsupportedError>()));

    final candidate = solver.fileSystem?.findBestCandidateToRemove(1000000000);
    expect(candidate, isNull);
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
