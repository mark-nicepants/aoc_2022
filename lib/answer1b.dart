import 'package:aoc/solver.dart';

/// By the time you calculate the answer to the Elves' question, they've already realized
/// that the Elf carrying the most Calories of food might eventually run out of snacks.
///
/// To avoid this unacceptable situation, the Elves would instead like to know the total
///  Calories carried by the top three Elves carrying the most Calories. That way, even
/// if one of those Elves runs out of snacks, they still have two backups.
///
/// In the example above, the top three Elves are the fourth Elf (with 24000 Calories),
///  then the third Elf (with 11000 Calories), then the fifth Elf (with 10000 Calories).
///  The sum of the Calories carried by these three elves is 45000.
///
/// Find the top three Elves carrying the most Calories.
/// How many Calories are those Elves carrying in total?

class Solver1b extends ISolver {
  @override
  String get key => '1b';

  @override
  String get question => 'Find the top three Elves carrying the most Calories.\n'
      'How many Calories are those Elves carrying in total?';

  @override
  int solve(List<String> input) {
    final totals = <int>[];
    int totalCalories = 0;

    for (var line in input) {
      if (line.isEmpty) {
        // More than all other elves store this one!
        totals.add(totalCalories);

        // Reset for the next count
        totalCalories = 0;
      } else {
        totalCalories += int.parse(line);
      }
    }

    totals.sort((l, r) => r.compareTo(l));

    return totals.sublist(0, totals.length < 3 ? totals.length : 3).reduce((value, element) => value + element);
  }
}
