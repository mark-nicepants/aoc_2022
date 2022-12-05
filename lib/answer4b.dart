import 'package:aoc/solver.dart';

/*
--- Part Two ---
It seems like there is still quite a bit of duplicate work planned. Instead, 
the Elves would like to know the number of pairs that overlap at all.

In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap, 
while the remaining four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do overlap:

5-7,7-9 overlaps in a single section, 7.
2-8,3-7 overlaps all of the sections 3 through 7.
6-6,4-6 overlaps in a single section, 6.
2-6,4-8 overlaps in sections 4, 5, and 6.
So, in this example, the number of overlapping assignment pairs is 4.

In how many assignment pairs do the ranges overlap?
*/

class Solver4b extends ISolver {
  @override
  String get key => '4b';

  @override
  String get question => 'In how many assignment pairs do the ranges overlap?';

  @override
  int solve(List<String> input) {
    return input.map(ElfGroup.fromInput).toList().where((element) => element.hasOverlap()).length;
  }
}

class ElfGroup {
  final Elf member1;
  final Elf member2;

  ElfGroup(this.member1, this.member2);

  factory ElfGroup.fromInput(String input) {
    final membersInput = input.split(',');
    return ElfGroup(
      Elf.fromInput(membersInput[0]),
      Elf.fromInput(membersInput[1]),
    );
  }

  bool hasOverlap() {
    return member1.overlaps(member2);
  }
}

class Elf {
  final int startSection;
  final int endSection;

  Elf(this.startSection, this.endSection);

  factory Elf.fromInput(String input) {
    return Elf(
      int.parse(input.split('-')[0]),
      int.parse(input.split('-')[1]),
    );
  }

  bool overlaps(Elf other) {
    return startSection <= other.endSection && other.startSection <= endSection;
  }
}
