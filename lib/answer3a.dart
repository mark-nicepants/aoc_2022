import 'package:file/local.dart';
import 'dart:io' as io;
/*
For example, suppose the Elves finish writing their items' Calories and end up with the following list:

1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
This list represents the Calories of the food carried by five Elves:

The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
The second Elf is carrying one food item with 4000 Calories.
The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
The fifth Elf is carrying one food item with 10000 Calories.
In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: they'd like to know how many Calories are being carried by the Elf carrying the most Calories. In the example above, this is 24000 (carried by the fourth Elf).

Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
 */

Future<void> main() async {
  final input = LocalFileSystem().file('${io.Directory.current.path}/lib/input/input3.txt');
  final answer = Solver3a().solve(await input.readAsLines());

  print("The top 3 elves with the most calories is carrying $answer calories");
}

class Solver3a {
  int solve(List<String> input) {
    return 0;
  }
}
