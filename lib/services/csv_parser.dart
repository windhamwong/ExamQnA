import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/question.dart';

class CsvParser {
  static Future<List<Question>> loadQuestions() async {
    try {
      final String data = await rootBundle.loadString('assets/questions.csv');
      
      // Configure CSV converter to handle quoted fields properly
      const converter = CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        textDelimiter: '"',
        shouldParseNumbers: false,
      );
      
      final List<List<dynamic>> csvData = converter.convert(data);

      // Skip header row and filter out empty rows
      final List<Question> questions = [];
      
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        
        // Skip empty rows
        if (row.isEmpty || row.every((cell) => cell.toString().trim().isEmpty)) {
          continue;
        }
        
        if (row.length >= 8) {
          try {
            final question = Question(
              category: row[0].toString().trim(),
              question: row[1].toString().trim(),
              choiceA: row[2].toString().trim(),
              choiceB: row[3].toString().trim(),
              choiceC: row[4].toString().trim(),
              choiceD: row[5].toString().trim(),
              correctAnswer: row[6].toString().trim(),
              explanation: row[7].toString().trim(),
            );
            
            // Validate that all fields are not empty
            if (question.category.isNotEmpty &&
                question.question.isNotEmpty &&
                question.choiceA.isNotEmpty &&
                question.choiceB.isNotEmpty &&
                question.choiceC.isNotEmpty &&
                question.choiceD.isNotEmpty &&
                question.correctAnswer.isNotEmpty &&
                question.explanation.isNotEmpty) {
              questions.add(question);
            }
          } catch (e) {
            // Skip invalid rows but continue processing
            print('Error parsing row $i: $e');
            continue;
          }
        } else {
          print('Row $i has insufficient columns: ${row.length}');
        }
      }

      if (questions.isEmpty) {
        throw Exception('No valid questions found in CSV file. Total rows processed: ${csvData.length - 1}');
      }

      return questions;
    } catch (e) {
      print('CSV Parser Error: $e');
      rethrow;
    }
  }
}

