import 'package:flutter/material.dart';
import 'task_list_screen.dart'; // شاشة عرض المهام المناسبة

class SurveyScreen extends StatefulWidget {
  final String groupTitle;

  const SurveyScreen(this.groupTitle, {super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // متغيرات لتخزين الإجابات المختارة
  String? selectedFeel;
  String? selectedEnergy;
  String? selectedFocus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupTitle} Survey'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Survey',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // السؤال الأول
              buildQuestion(
                'How do you feel today?',
                [
                  {'emoji': '😃', 'text': 'Happy'},
                  {'emoji': '😐', 'text': 'Neutral'},
                  {'emoji': '😢', 'text': 'Sad'},
                ],
                selectedFeel,
                (value) {
                  setState(() {
                    selectedFeel = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // السؤال الثاني
              buildQuestion(
                'What is your energy level?',
                [
                  {'emoji': '🌟', 'text': 'Low'},
                  {'emoji': '⚡', 'text': 'Medium'},
                  {'emoji': '🌞', 'text': 'High'},
                ],
                selectedEnergy,
                (value) {
                  setState(() {
                    selectedEnergy = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // السؤال الثالث
              buildQuestion(
                'How focused are you right now?',
                [
                  {'emoji': '🤔', 'text': 'A little focused'},
                  {'emoji': '🧐', 'text': 'Focused'},
                  {'emoji': '😵', 'text': 'Not focused'},
                ],
                selectedFocus,
                (value) {
                  setState(() {
                    selectedFocus = value;
                  });
                },
              ),

              const SizedBox(height: 40),

              // زر الإرسال
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // انتقل إلى شاشة عرض المهام المناسبة مع تمرير الإجابات
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskListScreen(
                          selectedFeel: selectedFeel,
                          selectedEnergy: selectedEnergy,
                          selectedFocus: selectedFocus,
                        ),
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(String question, List<Map<String, String>> answers,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...answers.map((answer) {
          return RadioListTile<String>(
            value: answer['text']!,
            groupValue: selectedValue,
            onChanged: onChanged,
            title: Row(
              children: [
                Text(
                  answer['emoji']!,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  answer['text']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
