
class Question{
  late String question;
  late String answer;
  List<dynamic> answers = [];
  late List<String> options;

  Question(this.question, this.answer, this.options);

  Question.ol(this.question, this.answers, this.options);
}