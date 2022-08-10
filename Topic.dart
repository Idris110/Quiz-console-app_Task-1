import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'QuestionBankJSON.dart' as quesBank;
import 'QuestionModel.dart' as QuestionBP;

int maxTime = 10; //max time allowed per question in seconds
int weightage = 1; //max mark for one question (one option)

abstract class Topic {
  //takes JSON string and returns list of shuffled question according to QuestionModel
  List<QuestionBP.Question> loadQuestions(List<dynamic> questions) {
    late List<QuestionBP.Question> questList = [];

    for (var question in questions) {
      late List<String> tempOpt = [];

      for (var option in question['incorrect_answers']) {
        tempOpt.add(option);
      }
      tempOpt = [...tempOpt, ...question['correct_answer']];
      tempOpt.shuffle();

      if (question['correct_answer'].length == 1)
        questList.add(QuestionBP.Question(
            question['question'], question['correct_answer'][0], tempOpt));
      else
        questList.add(QuestionBP.Question.ol(
            question['question'], question['correct_answer'], tempOpt));
    }
    return questList;
  }

  Map<String, int> beginQuiz(List<QuestionBP.Question> questionList) {
    questionList.shuffle();
    int maxScore = 0, score = 0;
    int quesNo = 0;

    int renderQuest(var questObj) { //displays question and returns score for each question
      int noOfOpts = questObj.answers.length;

      print("\nQ${++quesNo}. ${questObj.question}");
      for (var i = 0; i < questObj.options.length; i++) {
        stdout.write(i + 1);
        print(". ${questObj.options[i]}");
      }

      if (noOfOpts == 0) {
        late int selected;
        stdout.write("Answer (single answer) : ");
        selected = int.parse(stdin.readLineSync()!);
        maxScore = maxScore + 1;
        if (selected <= 4 &&
            questObj.options[selected - 1] == questObj.answer) {
          // score = correctAns(score);
          print("=> Correct Answer");
          return 1;
        } else {
          // score = incorrectAns(score);
          print("=> Incorrect Answer");
        }
      } else {
        stdout.write("Answer (multiple answers) : ");
        List<int> selected = [];
        for (var i = 0; i < noOfOpts; i++) {
          selected.add(int.parse(stdin.readLineSync()!));
        }
        int matched = 0;

        for (var i = 0; i < selected.length; i++) {
          for (var ans in questObj.answers) {
            if (selected[i] <= 4 && questObj.options[selected[i] - 1] == ans)
              matched++;
          }
        }
        maxScore = maxScore + noOfOpts;
        if (matched == noOfOpts) {
          // score = correctAns(score);
          print("=> Correct Answer");
        } else {
          // score = incorrectAns(score);
          print("=> ${noOfOpts - matched} incorrect answer");
        }
        return matched;
      }
      return 0;
    }

    for (var questObj in questionList) { // Quiz begins here
      final stopwatch = Stopwatch()..start();
      int scored = renderQuest(questObj);
      int timeTaken = stopwatch.elapsed.inSeconds;
      if (timeTaken > maxTime) {
        print("** Exceeded time limit of ${maxTime} secs !");
      } else {
        score += scored;
      }
    }

    print("\n\t** Correct Answers :");
    quesNo = 0;
    for (var questObj in questionList) {
      print("\nQ${++quesNo}. ${questObj.question}");

      if (questObj.answers.length == 0)
        print("Ans. ${questObj.answer}");
      else {
        for (var ans in questObj.answers) {
          print("Ans. ${ans}");
        }
      }
    }
    return {'scored': (score * weightage), 'outOf': (maxScore * weightage)};
  }

  Map<String, int> displayQuestions();
}

abstract class Result {
  void getMarks();

  int correctAns(
      int score); // functions called when option is correct/incorrect
  int incorrectAns(int score);
}

class Math extends Topic implements Result {
  var mathQues = json.decode(quesBank.qb.mathQuesJSON)['results'];

  Math() {
    getMarks();
  }

  @override
  void getMarks() {
    Map<String, int> score = displayQuestions();

    print(
        "\n** Hurray you scored ${score['scored']} out of ${score['outOf']} **\n\n");
  }

  @override
  Map<String, int> displayQuestions() {
    List<QuestionBP.Question> questionList =
        loadQuestions(mathQues); //renders question from JSON
    Map<String, int> score = beginQuiz(questionList);

    return score;
  }

  @override
  int correctAns(int score) {
    print("Correct Answer !");
    return score + 1;
  }

  @override
  int incorrectAns(int score) {
    print("Wrong Answer !");
    return score;
  }
}

class Java extends Topic implements Result {
  var javaQues = json.decode(quesBank.qb.javaQuesJSON)['results'];

  Java() {
    getMarks();
  }

  @override
  void getMarks() {
    Map<String, int> score = displayQuestions();

    print(
        "\n** Hurray you scored ${score['scored']} out of ${score['outOf']} **\n\n");
  }

  @override
  Map<String, int> displayQuestions() {
    List<QuestionBP.Question> questionList =
        loadQuestions(javaQues); //renders question from JSON
    Map<String, int> score = beginQuiz(questionList);

    return score;
  }

  @override
  int correctAns(int score) {
    print("Correct Answer !");
    return score + 1;
  }

  @override
  int incorrectAns(int score) {
    print("Wrong Answer !");
    return score;
  }
}
