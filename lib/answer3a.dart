import 'package:aoc/solver.dart';
import 'package:equatable/equatable.dart';
/*
Every set of three lines in your list corresponds to a single group, but each group can have a different badge item type. So, in the above example, the first group's rucksacks are the first three lines:

vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
And the second group's rucksacks are the next three lines:

wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
In the first group, the only item type that appears in all three rucksacks is lowercase r; this must be their badges. In the second group, their badge item type must be Z.

Priorities for these items must still be found to organize the sticker attachment efforts: here, they are 18 (r) for the first group and 52 (Z) for the second group. The sum of these is 70.

Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?
 */

class Solver3a extends ISolver {
  @override
  String get key => '3a';

  @override
  String get question => 'Find the item type that corresponds to the badges of each three-Elf group.\n'
      'What is the sum of the priorities of those item types?';

  @override
  int solve(List<String> input) {
    final output = input
        .map((line) => RuckSack.fromInput(line))
        .map((rucksack) => rucksack.sharedItems.first.priority)
        .fold<int>(0, (prev, element) => prev + element);

    return output;
  }
}

class RuckSack {
  final Compartment compartment1;
  final Compartment compartment2;

  RuckSack(this.compartment1, this.compartment2);

  factory RuckSack.fromInput(String input) {
    return RuckSack(
      Compartment.fromInput(input.firstHalf),
      Compartment.fromInput(input.secondHalf),
    );
  }

  List<Item> get sharedItems {
    return compartment1.sharedItems(compartment2);
  }
}

class Compartment {
  final List<Item> items;

  Compartment(this.items);

  factory Compartment.fromInput(String input) {
    return Compartment(input.split('').map(Item.new).toList());
  }

  List<Item> sharedItems(Compartment other) {
    final shared = <Item>[];
    for (var element in items) {
      if (other.items.contains(element)) {
        shared.add(element);
      }
    }
    return shared;
  }
}

class Item extends Equatable {
  final String value;

  Item(this.value);

  int get priority => charPriority.indexOf(value) + 1;

  @override
  List<Object?> get props => [value];
}

extension StringEx on String {
  String get firstHalf {
    final halfLength = length ~/ 2;
    return substring(0, halfLength);
  }

  String get secondHalf {
    final halfLength = length ~/ 2;
    return substring(halfLength, length);
  }
}

final charPriority = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
