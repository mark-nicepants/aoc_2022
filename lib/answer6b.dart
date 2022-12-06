import 'dart:math';

import 'package:aoc/solver.dart';

/// Your device's communication system is correctly detecting packets, but still isn't
/// working. It looks like it also needs to look for messages.
///
/// A start-of-message marker is just like a start-of-packet marker, except it consists
/// of 14 distinct characters rather than 4.
///
/// Here are the first positions of start-of-message markers for all of the above examples:
///
/// mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
/// bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
/// nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
/// nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
/// zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26
///
/// How many characters need to be processed before the first start-of-message marker is detected?

class Solver6b extends ISolver {
  @override
  String get key => '6b';

  @override
  String get question =>
      'How many characters need to be processed before the first start-of-message marker is detected?';

  @override
  int solve(List<String> input) {
    // This puzzle only processes 1 row of data.
    final line = input[0];
    final codeLength = 14;

    for (var i = 0; i < line.length; i++) {
      final end = min(line.length, i + codeLength);
      final code = line.substring(i, end);

      if (_uniqueChars(code) == codeLength) {
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
