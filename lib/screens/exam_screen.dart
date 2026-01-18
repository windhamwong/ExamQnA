import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/csv_parser.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<Question> _allQuestions = [];
  Question? _currentQuestion;
  String? _selectedAnswer;
  bool _showAnswer = false;
  bool _isLoading = true;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await CsvParser.loadQuestions();
      if (questions.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No questions found in the CSV file. Please check the file format.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }
      setState(() {
        _allQuestions = questions;
        _isLoading = false;
      });
      _getNextQuestion();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading questions: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      print('Error loading questions: $e');
    }
  }

  void _getNextQuestion() {
    if (_allQuestions.isEmpty) return;

    setState(() {
      _currentQuestion = _allQuestions[_random.nextInt(_allQuestions.length)];
      _selectedAnswer = null;
      _showAnswer = false;
    });
  }

  void _selectAnswer(String answer) {
    if (_showAnswer) return;

    setState(() {
      _selectedAnswer = answer;
      _showAnswer = true;
    });
  }

  Color _getChoiceColor(String choice) {
    if (!_showAnswer) {
      return _selectedAnswer == choice
          ? Colors.blue.shade100
          : Colors.grey.shade100;
    }

    final choiceLetter = _getChoiceLetter(choice);
    final isCorrect = _currentQuestion!.isCorrect(choiceLetter);
    final isSelected = _selectedAnswer == choice;

    if (isCorrect) {
      return Colors.green.shade300;
    } else if (isSelected && !isCorrect) {
      return Colors.red.shade300;
    }
    return Colors.grey.shade100;
  }

  String _getChoiceLetter(String choice) {
    if (choice == _currentQuestion!.choiceA) return 'A';
    if (choice == _currentQuestion!.choiceB) return 'B';
    if (choice == _currentQuestion!.choiceC) return 'C';
    if (choice == _currentQuestion!.choiceD) return 'D';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Simulation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentQuestion == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('No questions available'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        child: const Text('Reload Questions'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _currentQuestion!.category,
                                  style: TextStyle(
                                    color: Colors.purple.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentQuestion!.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Choices
                      _buildChoiceButton('A', _currentQuestion!.choiceA),
                      const SizedBox(height: 12),
                      _buildChoiceButton('B', _currentQuestion!.choiceB),
                      const SizedBox(height: 12),
                      _buildChoiceButton('C', _currentQuestion!.choiceC),
                      const SizedBox(height: 12),
                      _buildChoiceButton('D', _currentQuestion!.choiceD),
                      const SizedBox(height: 24),

                      // Answer and Explanation
                      if (_showAnswer) ...[
                        Card(
                          color: _currentQuestion!.isCorrect(_getChoiceLetter(_selectedAnswer!))
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _currentQuestion!.isCorrect(_getChoiceLetter(_selectedAnswer!))
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: _currentQuestion!.isCorrect(_getChoiceLetter(_selectedAnswer!))
                                          ? Colors.green
                                          : Colors.red,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _currentQuestion!.isCorrect(_getChoiceLetter(_selectedAnswer!))
                                          ? 'Correct!'
                                          : 'Incorrect',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _currentQuestion!.isCorrect(_getChoiceLetter(_selectedAnswer!))
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Correct Answer: ${_currentQuestion!.correctAnswer}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Explanation:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _currentQuestion!.explanation,
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.6,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Next Question Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _showAnswer ? _getNextQuestion : null,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text(
                            'Next Question',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildChoiceButton(String letter, String choice) {
    final isSelected = _selectedAnswer == choice;
    final choiceColor = _getChoiceColor(choice);
    final choiceLetter = _getChoiceLetter(choice);
    final isCorrect = _showAnswer && _currentQuestion!.isCorrect(choiceLetter);

    return InkWell(
      onTap: () => _selectAnswer(choice),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: choiceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blue.shade400
                : (_showAnswer && isCorrect)
                    ? Colors.green.shade400
                    : Colors.grey.shade300,
            width: isSelected || (_showAnswer && isCorrect) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected || (_showAnswer && isCorrect)
                    ? Colors.blue.shade600
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                choice,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            if (_showAnswer && isCorrect)
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
            if (_showAnswer && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.red, size: 24),
          ],
        ),
      ),
    );
  }
}

