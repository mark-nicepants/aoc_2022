import 'package:aoc/solver.dart';

/// Some of the pairs have noticed that one of their assignments fully contains the other.
/// For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6.
/// In pairs where one assignment fully contains the other, one Elf in the pair would
/// be exclusively cleaning sections their partner will already be cleaning, so these
/// seem like the most in need of reconsideration. In this example, there are 2 such pairs.
///
/// In how many assignment pairs does one range fully contain the other?

class Solver4a extends ISolver {
  @override
  String get key => '4a';

  @override
  String get question => 'In how many assignment pairs does one range fully contain the other?';

  @override
  int solve(List<String> input) {
    return input.map(ElfGroup.fromInput).toList().where((element) => element.oneContainsOther()).length;
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

  bool oneContainsOther() {
    return member1.contains(member2) || member2.contains(member1);
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

  bool contains(Elf other) {
    final startsSameOrLater = other.startSection >= startSection;
    final endsSameOrEarlier = other.endSection <= endSection;

    return startsSameOrLater && endsSameOrEarlier;
  }
}
