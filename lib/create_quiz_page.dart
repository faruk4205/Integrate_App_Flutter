import 'package:flutter/material.dart';

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _questions = [];
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers =
  List.generate(4, (index) => TextEditingController());
  int _correctAnswerIndex = 0;

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answers = _answerControllers.map((controller) => controller.text).toList();
      _questions.add({
        'question': question,
        'answers': answers.join('|'),
        'correctAnswer': answers[_correctAnswerIndex],
      });
      _questionController.clear();
      _answerControllers.forEach((controller) => controller.clear());
      setState(() {
        _correctAnswerIndex = 0;
      });
    }
  }

  void _submitQuiz() {
    // Here you would handle quiz submission, e.g., save to a database or share with others.
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Own Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              ...List.generate(4, (index) {
                return ListTile(
                  title: TextFormField(
                    controller: _answerControllers[index],
                    decoration: InputDecoration(labelText: 'Answer ${index + 1}'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _correctAnswerIndex,
                    onChanged: (value) {
                      setState(() {
                        _correctAnswerIndex = value!;
                      });
                    },
                  ),
                );
              }),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
              SizedBox(height: 20),
              if (_questions.isNotEmpty)
                ElevatedButton(
                  onPressed: _submitQuiz,
                  child: Text('Submit Quiz'),
                ),
              if (_questions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _questions.map((question) {
                    return ListTile(
                      title: Text(question['question']!),
                      subtitle: Text('Correct Answer: ${question['correctAnswer']}'),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
