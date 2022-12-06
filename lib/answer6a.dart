import 'dart:math';

import 'package:aoc/solver.dart';

/// For example, suppose you receive the following datastream buffer:
///
/// mjqjpqmgbljsphdztnvjfqwrcgsmlb
/// After the first three characters (mjq) have been received, there haven't been enough characters received yet to find the marker. The first time a marker could occur is after the fourth character is received, making the most recent four characters mjqj. Because j is repeated, this isn't a marker.
///
/// The first time a marker appears is after the seventh character arrives. Once it does, the last four characters received are jpqm, which are all different. In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.
///
/// Here are a few more examples:
///
/// bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
/// nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
/// nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
/// zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11
///
/// How many characters need to be processed before the first start-of-packet marker is detected?

class Solver6a extends ISolver {
  @override
  String get key => '6a';

  @override
  String get question =>
      'How many characters need to be processed before the first start-of-packet marker is detected?';

  @override
  int solve(List<String> input) {
    // This puzzle only processes 1 row of data.
    final line = input[0];
    final codeLength = 4;

    for (var i = 0; i < line.length; i++) {
      final end = min(line.length, i + codeLength);
      final code = line.substring(i, end);

      if (_uniqueChars(code) == 4) {
        return i + codeLength;
      }
    }

    return -1;
  }

  int _uniqueChars(String chars) {
    var uniqueCount = 0;
    final checked = <String>[];

    for (var element in chars.split('')) {
      if (!checked.contains(element)) {
        uniqueCount++;
        checked.add(element);
      }
    }
    return uniqueCount;
  }
}
