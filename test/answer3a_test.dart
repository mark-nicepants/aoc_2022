import 'package:aoc/answer3a.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('3a. What is the sum of the priorities of those item types?', () {
    final solver = Solver3a();

    expect(solver.key, '3a');
    expect(solver.question, startsWith('Find the item type that corresponds to the badges'));

    expect('p', same(RuckSack.fromInput(input[0]).sharedItems.first.value));
    expect('L', same(RuckSack.fromInput(input[1]).sharedItems.first.value));
    expect('P', same(RuckSack.fromInput(input[2]).sharedItems.first.value));
    expect('v', same(RuckSack.fromInput(input[3]).sharedItems.first.value));
    expect('t', same(RuckSack.fromInput(input[4]).sharedItems.first.value));
    expect('s', same(RuckSack.fromInput(input[5]).sharedItems.first.value));

    expect(16, same(charPriority.indexOf('p') + 1));
    expect(38, same(charPriority.indexOf('L') + 1));
    expect(42, same(charPriority.indexOf('P') + 1));
    expect(22, same(charPriority.indexOf('v') + 1));
    expect(20, same(charPriority.indexOf('t') + 1));
    expect(19, same(charPriority.indexOf('s') + 1));

    expect(157, same(solver.solve(input)));
  });
}

final input = [
  'vJrwpWtwJgWrhcsFMMfFFhFp',
  'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
  'PmmdzqPrVvPwwTWBwg',
  'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
  'ttgJtRGJQctTZtZT',
  'CrZsJsPPZsGzwwsLwLmpwMDw',
];
