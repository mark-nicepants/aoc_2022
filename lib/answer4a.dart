import 'dart:io';

import 'package:file/local.dart';

Future<void> main() async {
  final input = LocalFileSystem().file('${Directory.current.path}/lib/input/input4.txt');
  final answer = Solver4a().solve(await input.readAsLines());

  print("In how many assignment pairs does one range fully contain the other? Answer: $answer");
}

class Solver4a {
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
