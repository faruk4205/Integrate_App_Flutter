import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  ProfilePage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _resumeFile;

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Color.fromARGB(255, 183, 224, 252),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Faruk Ahmed',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Undergraduate Researcher, 4IR Research Cell\nDaffodil International University',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Professional Summary'),
              Text(
                'A student researcher skilled in programming languages and Machine Learning techniques. Strong communicator with proven teamwork and project management abilities. Fluent in English and Bengali, with a knack for analytical thinking and problem-solving. Eager to contribute to innovative research in a dynamic lab setting.',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Skills'),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <String>[
                  'Machine Learning',
                  'IoT',
                  'Artificial Intelligence',
                  'Data Analysis',
                  'Research & Development',
                  'Project Management',
                  'FLutter',
                  'HTML',
                  'CSS',
                  'Qualititive Research'
                ].map((skill) => Chip(label: Text(skill))).toList(),
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 32),
              _buildSectionTitle('Education'),
              _buildEducationItem(
                'B.Sc. in Computer Science and Engineering',
                'Daffodil International University',
                'Current CGPA: 3.95 out of 4.00\nGraduation Year: 2021 - 2024',
              ),
              _buildEducationItem(
                'H.S.C. in Science',
                'Notre Dame College, Dhaka',
                'Result: 5.00 out of 5.00\nYear: 2017 - 2019',
              ),
              _buildEducationItem(
                'S.S.C in Science',
                'Saint Marthas High School',
                'Result: 5.00 out of 5.00\nYear: 2015 - 2016',
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Experience'),
              ProjectCard(
                title: 'Undergraduate Researcher, 4IR Research Cell',
                description: '''Daffodil International University
2023 - Present
Writing rigorous research papers and working on various research projects focused on AI, IoT, and machine learning to drive innovation and technological advancement.''',
              ),
              ProjectCard(
                title: 'IELTS Tutor',
                description: '''English Buddy
2019 - 2021
Conducted lectures on IELTS and guided students to get a good score in IELTS.''',
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Publications'),
              ProjectCard(
                title: 'Book Chapters',
                description: '''* Chapter 4: IDEs in Blockchain; Blockchain in practice and research: The key to digital security; Daffodil International University Press.
* Chapter 4: Biomedical Engineering in Fatal Disease Diagnosis; Biomedical engineering in practice and research: Artificial intelligence in search of disease; Daffodil International University Press.
* Deep Learning Applications and Methods for Biomedical Engineering and Health Informatics. (Ongoing)''',
              ),
              ProjectCard(
                title: 'Conferences',
                description: '''* A Fuzzy-Based Vision Transformer Model for Tea Leaf Disease Detection, TCCE Conference 2023, Springer (Accepted and will be available in June 2024)
* Analysing Litchi Leaves Disease through Vision Transformer (ViT) Technology. (Submitted to IEEE Conference) 
* Drug Addiction Analysis in Bangladesh using Machine Learning. (Ready to submit)''',
              ),
              ProjectCard(
                title: 'arXiv Pre-Print Paper',
                description: '''* Machine Learning-Based Tea Leaf Disease Detection: A Comprehensive Review. (Available Online)
* A Comprehensive Literature Review on Sweet Orange Leaf Diseases. (Available Online)''',
              ),
              ProjectCard(
                title: 'Journals',
                description: '''* Unfolding the affordances of Micro-credential (MC) for higher education (HE). (Submitted to Q1)
* A study on Deep convolutional neural networks, transfer learning  and ensemble model for Breast Cancer Detection. (Submitted to Q1)
* Blood cancer detection using a novel CNN-based ensemble approach. (Submitted to Q1)
* Baccaurea ramiflora Leaf Disease Detection using ViT. (Submitted to Q2)
* Aiming to improve the accuracy of grape leaf disease detection using a vision transformer. (Ready to submit)
* A Comparison of Vision Transformer and YOLOv8 in Semantic Segmentation using Mango Leaf. (Ready to Submit)
* A Machine Learning Approach for Thyroid Disease Prediction. (Ongoing)
* Lemon Leaf Disease Classification using Vision Transformer. (Ongoing)''',
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Upload Resume/CV'),
              Center(
                child: ElevatedButton(
                  onPressed: _pickResume,
                  child: Text('Upload Resume/CV'),
                ),
              ),
              if (_resumeFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Uploaded: ${_resumeFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Social Media'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    color: Color.fromARGB(255, 196, 74, 100),
                    iconSize: 40,
                    onPressed: facebook_url,
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.github),
                    color: Color.fromARGB(255, 202, 46, 93),
                    iconSize: 40,
                    onPressed: github_url,
                  ),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.linkedin),
                      color: Color.fromARGB(255, 204, 86, 111),
                      iconSize: 43,
                      onPressed: linked_in_url),
                      IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram),
                      color: Color.fromARGB(255, 207, 90, 90),
                      iconSize: 43,
                      onPressed: instagram_url),
                ],
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Blog'),
              Center(
              child: BlogSection(),
              ),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Achievements & Certifications'),
              ProjectCard(
                title: 'Competitions',
                description: '''* Champion on Crack Dataset contest organized by DIU ML & NLP Lab.
* Online round winner at Green Earth Quest quiz organized by World Bank.
* Secured 21st Position at Take-Off Organized by DIU-CPC.''',
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _pickResume,
                  child: Text('Upload Achievements/Certifications'),
                ),
              ),
              if (_resumeFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Uploaded: ${_resumeFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              SizedBox(height: 24),
              Divider(color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 65, 3, 236)),
 _buildSectionTitle('Contact Information'),
ListTile(
  leading: Icon(Icons.email),
  title: Row(
    children: [
      TextButton(
        onPressed: () => launch('mailto:faruk15-4205@diu.edu.bd'),
        child: Text('faruk15-4205@diu.edu.bd'),
      ),
    ],
  ),
),
ListTile(
  leading: Icon(Icons.phone),
  title: Row(
    children: [
      TextButton(
        onPressed: () => launch('tel:+8801611193974'),
        child: Text('+8801611193974'),
      ),
    ],
  ),
),
ListTile(
  leading: Icon(Icons.web),
  title: Row(
    children: [
      TextButton(
        onPressed: () => launch('https://sites.google.com/diu.edu.bd/faruk4205/home'),
        child: Text('https://sites.google.com/diu.edu.bd/faruk4205/home'),
      ),
    ],
  ),
),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: widget.isDarkMode ? Colors.white : Colors.blueAccent,
      ),
    );
  }

  Widget _buildEducationItem(String degree, String institution, String period) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school, color: widget.isDarkMode ? Colors.white : Colors.blueAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  degree,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  institution,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(String title, String company, String period, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.work, color: widget.isDarkMode ? Colors.white : Colors.blueAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

linked_in_url() async {
  const url = 'https://www.linkedin.com/in/faruk-ahmed-21806b248/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

facebook_url() async {
  const url = 'https://web.facebook.com/faruk.riyad077/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

github_url() async {
  const url = 'https://github.com/faruk4205';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

instagram_url() async {
  const url = 'https://www.instagram.com/faruk_riyad?igsh=Y2dhdGZuOG12dXE=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  ProjectCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                //color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                //color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogSection extends StatefulWidget {
  @override
  _BlogSectionState createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  final List<Map<String, String>> _blogPosts = [];

  void _addBlogPost() {
  showDialog(
    context: context,
    builder: (context) {
      final titleController = TextEditingController();
      final contentController = TextEditingController();
      return AlertDialog(
        title: Text('New Blog Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          Center(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _blogPosts.add({
                        'title': titleController.text,
                        'content': contentController.text,
                      });
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _addBlogPost,
          child: Text('Add Blog Post'),
        ),
        ..._blogPosts.map((post) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //color: widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    post['content']!,
                    style: TextStyle(
                      //color: widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
