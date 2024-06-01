import 'package:farukapp/quiz_level_page.dart';
import 'package:flutter/material.dart';
import 'create_quiz_page.dart';
import 'leaderboard_page.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'Flutter Quiz',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Test your Flutter knowledge!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                QuizModeButton(
                  title: 'Timed Quiz',
                  description: 'Complete the quiz within a time limit.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizLevelPage(mode: 'Timed'),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Practice Mode',
                  description: 'Practice without a time limit.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizLevelPage(mode: 'Practice'),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Create Your Own Quiz',
                  description: 'Create and share your own quizzes.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateQuizPage(),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Leaderboard',
                  description: 'View the top scores.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizModeButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  QuizModeButton({required this.title, required this.description, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onPressed,
      ),
    );
  }
}
