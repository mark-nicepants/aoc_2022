import 'package:aoc/answer3b.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('3b. What is the sum of the priorities of those item types?', () {
    final solver = Solver3b();

    final rucksacks = input.map(RuckSack.fromInput).toList();
    final groups = ElfGroup.fromRuckSacks(rucksacks, 3);

    expect('p', same(rucksacks[0].sharedItems.first.value));
    expect('L', same(rucksacks[1].sharedItems.first.value));
    expect('P', same(rucksacks[2].sharedItems.first.value));
    expect('v', same(rucksacks[3].sharedItems.first.value));
    expect('t', same(rucksacks[4].sharedItems.first.value));
    expect('s', same(rucksacks[5].sharedItems.first.value));

    expect(16, same(charPriority.indexOf('p') + 1));
    expect(38, same(charPriority.indexOf('L') + 1));
    expect(42, same(charPriority.indexOf('P') + 1));
    expect(22, same(charPriority.indexOf('v') + 1));
    expect(20, same(charPriority.indexOf('t') + 1));
    expect(19, same(charPriority.indexOf('s') + 1));

    expect('r', same(groups[0].badge.value));
    expect(18, same(groups[0].badge.priority));
    expect('Z', same(groups[1].badge.value));
    expect(52, same(groups[1].badge.priority));

    expect(70, same(solver.solve(input)));
  });
}

final input = [
  // Group 1 (every 3 lines is a group)
  'vJrwpWtwJgWrhcsFMMfFFhFp',
  'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
  'PmmdzqPrVvPwwTWBwg',
  // Group 2
  'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
  'ttgJtRGJQctTZtZT',
  'CrZsJsPPZsGzwwsLwLmpwMDw',
];
