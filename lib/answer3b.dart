import 'package:equatable/equatable.dart';
import 'package:file/local.dart';
import 'dart:io' as io;
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

Future<void> main() async {
  final input = LocalFileSystem().file('${io.Directory.current.path}/lib/input/input3.txt');
  final answer = Solver3b().solve(await input.readAsLines());

  print("What is the sum of the priorities of those item types? Answer: $answer");
}

class Solver3b {
  int solve(List<String> input) {
    final output = input
        .map((line) => RuckSack.fromInput(line))
        .map((rucksack) => rucksack.sharedItems.first.priority)
        .fold<int>(0, (prev, element) => prev + element);

    return output;
  }
}

class ElfGroup {
  final List<RuckSack> members;
  final Item badge;

  ElfGroup(this.members) : badge = Item.findBadgeInGroup(members);

  static List<ElfGroup> fromRuckSacks(List<RuckSack> rucksacks, int groupSize) {
    final groups = <ElfGroup>[];
    for (var i = 0; i < rucksacks.length; i += groupSize) {
      groups.add(ElfGroup(rucksacks.sublist(i, i + groupSize)));
    }
    return groups;
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

  List<Item> get uniqueItems {
    return <Item>{
      ...compartment1.items,
      ...compartment2.items,
    }.toList();
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

  static Item findBadgeInGroup(List<RuckSack> members) {
    final itemCounts = <Item, int>{};
    for (final member in members) {
      for (final item in member.uniqueItems) {
        itemCounts[item] = (itemCounts[item] ?? 0) + 1;
      }
    }

    Item? badge;
    itemCounts.forEach((key, value) {
      if (value == members.length) {
        badge = key;
      }
    });

    if (badge != null) {
      return badge!;
    } else {
      throw 'No group badge found';
    }
  }
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
