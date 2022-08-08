import 'dart:io';

import 'Topic.dart' as Topic;

void main(List<String> args) {
  // new Topic.Math();
  
  late int repeat, choice;
  
  do {
    print("\tEnter your choice\n\t1. Maths quiz\n\t2. Java quiz");
    stdout.write(" ==> ");
    choice = int.parse(stdin.readLineSync()!);
    switch (choice) {
      case 1:
        new Topic.Math();
        break;
      case 2:
        new Topic.Java();
        break;
      default:
        print("Enter valid choice !");
    }

    print("\tEnter 1 to repeat the Quiz\n\tEnter 0 to exit : ");
    stdout.write(" ==> ");
    repeat = int.parse(stdin.readLineSync()!);
  } while (repeat != 0);
}