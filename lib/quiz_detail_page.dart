import 'package:farukapp/questions.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuizDetailPage extends StatefulWidget {
  final int level;
  final String mode;

  QuizDetailPage({required this.level, required this.mode});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _answered = false;
  bool _isTimedMode = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _timer;
  int _remainingTime = 10;
  final int _totalTime = 10; // total time for each question

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
    if (widget.mode == 'Timed') {
      _isTimedMode = true;
      _startTimer();
    }
  }

  void _loadQuestions() {
    switch (widget.level) {
      case 1:
        _questions = level1Questions;
        break;
      case 2:
        _questions = level2Questions;
        break;
      case 3:
        _questions = level3Questions;
        break;
      case 4:
        _questions = level4Questions;
        break;
      default:
        _questions = [];
    }
  }

  void _answerQuestion(int score) {
    setState(() {
      _answered = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _totalScore += score;
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
      });
      if (_currentQuestionIndex < _questions.length) {
        _controller.reset();
        _controller.forward();
        if (_isTimedMode) {
          _startTimer();
        }
      } else {
        _showResult();
      }
    });
  }

  void _startTimer() {
    _remainingTime = _totalTime;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer!.cancel();
          _answerQuestion(0); // Automatically answer with 0 score when time is up
        }
      });
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your score is $_totalScore.'),
            SizedBox(height: 20),
            Text('Explanations:'),
            ..._questions.map((question) {
              return ListTile(
                title: Text(question['question'] as String),
                subtitle: Text(question['explanation'] as String),
              );
            }).toList(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level} Quiz'),
        actions: _isTimedMode
            ? [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ClockTimer(
                remainingTime: _remainingTime,
                totalTime: _totalTime,
              ),
            ),
          ),
        ]
            : null,
      ),
      body: _currentQuestionIndex < _questions.length
          ? SlideTransition(
        position: _animation,
        child: QuizQuestion(
          question: _questions[_currentQuestionIndex]['question'] as String,
          answers: _questions[_currentQuestionIndex]['answers']
          as List<Map<String, Object>>,
          answerQuestion: _answerQuestion,
          answered: _answered,
        ),
      )
          : Center(
        child: Text('No more questions.'),
      ),
    );
  }
}

class QuizQuestion extends StatelessWidget {
  final String question;
  final List<Map<String, Object>> answers;
  final Function answerQuestion;
  final bool answered;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.answerQuestion,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          ...answers.map((answer) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: answered
                    ? (answer['score'] == 1 ? Colors.green : Colors.red)
                    : Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  answer['text'] as String,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: answered
                    ? null
                    : () => answerQuestion(answer['score']),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ClockTimer extends StatelessWidget {
  final int remainingTime;
  final int totalTime;

  ClockTimer({required this.remainingTime, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: remainingTime / totalTime,
          strokeWidth: 8.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(remainingTime > 10
              ? Colors.green
              : remainingTime > 5
              ? Colors.orange
              : Colors.red),
        ),
        Text(
          '$remainingTime',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
