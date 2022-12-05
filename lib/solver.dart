abstract class ISolver {
  String get question;
  String get key;

  Object solve(List<String> input);

  String printSolve(List<String> input) {
    final answer = solve(input);
    return "$key. $question\n\nAnswer = $answer";
  }
}
