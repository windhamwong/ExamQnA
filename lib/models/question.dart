class Question {
  final String category;
  final String question;
  final String choiceA;
  final String choiceB;
  final String choiceC;
  final String choiceD;
  final String correctAnswer;
  final String explanation;

  Question({
    required this.category,
    required this.question,
    required this.choiceA,
    required this.choiceB,
    required this.choiceC,
    required this.choiceD,
    required this.correctAnswer,
    required this.explanation,
  });

  List<String> get choices => [choiceA, choiceB, choiceC, choiceD];

  bool isCorrect(String selectedAnswer) {
    return selectedAnswer.trim().toUpperCase() == correctAnswer.trim().toUpperCase();
  }

  String getChoiceByLetter(String letter) {
    switch (letter.toUpperCase()) {
      case 'A':
        return choiceA;
      case 'B':
        return choiceB;
      case 'C':
        return choiceC;
      case 'D':
        return choiceD;
      default:
        return '';
    }
  }
}

