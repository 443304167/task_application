// import 'package:flutter/material.dart';

// class TaskListScreen extends StatelessWidget {
//   final String? selectedFeel;
//   final String? selectedEnergy;
//   final String? selectedFocus;

//   TaskListScreen({
//     super.key,
//     required this.selectedFeel,
//     required this.selectedEnergy,
//     required this.selectedFocus,
//   });

//   // قائمة المهام الوهمية
//   final List<Map<String, String>> tasks = [
//     {'title': 'Study Math', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Do Yoga', 'priority': 'Medium', 'focus': 'A little focused'},
//     {'title': 'Watch TV', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Complete Project', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Read a Book', 'priority': 'Medium', 'focus': 'Focused'},
//     {'title': 'Clean the House', 'priority': 'Low', 'focus': 'A little focused'},
//     {'title': 'Write an Essay', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Take a Walk', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Plan the Week', 'priority': 'Medium', 'focus': 'Focused'},
//     {'title': 'Meditate', 'priority': 'Low', 'focus': 'A little focused'},
//     {'title': 'Prepare for Presentation', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Organize Files', 'priority': 'Medium', 'focus': 'A little focused'},
//     {'title': 'Listen to a Podcast', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Learn a New Skill', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Call a Friend', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Write a Journal Entry', 'priority': 'Medium', 'focus': 'A little focused'},
//     {'title': 'Cook Dinner', 'priority': 'Medium', 'focus': 'A little focused'},
//     {'title': 'Fix the Bike', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Prepare Meeting Notes', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Exercise at Gym', 'priority': 'Medium', 'focus': 'Focused'},
//     {'title': 'Watch a Documentary', 'priority': 'Low', 'focus': 'A little focused'},
//     {'title': 'Brainstorm Ideas', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Play a Game', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Research for Article', 'priority': 'Medium', 'focus': 'Focused'},
//     {'title': 'Relax with Music', 'priority': 'Low', 'focus': 'Not focused'},
//     {'title': 'Review Class Notes', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Create a Budget', 'priority': 'Medium', 'focus': 'A little focused'},
//     {'title': 'Attend Online Class', 'priority': 'High', 'focus': 'Focused'},
//     {'title': 'Sort Email Inbox', 'priority': 'Low', 'focus': 'A little focused'},
//     {'title': 'Work on Coding Project', 'priority': 'High', 'focus': 'Focused'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final filteredTasks = tasks.where((task) {
//       // تصفية المهام بناءً على نتائج الاستبيان
//       if (selectedFocus == 'Focused' && task['focus'] == 'Focused') {
//         return true;
//       } else if (selectedFocus == 'A little focused' &&
//           task['focus'] == 'A little focused') {
//         return true;
//       } else if (selectedFocus == 'Not focused' && task['focus'] == 'Not focused') {
//         return true;
//       }
//       return false;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recommended Tasks'),
//       ),
//       body: filteredTasks.isEmpty
//           ? const Center(
//               child: Text('No tasks match your current state.'),
//             )
//           : ListView.builder(
//               itemCount: filteredTasks.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.task,
//                       color: _getPriorityColor(filteredTasks[index]['priority']!),
//                     ),
//                     title: Text(
//                       filteredTasks[index]['title']!,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       'Priority: ${filteredTasks[index]['priority']} | Focus: ${filteredTasks[index]['focus']}',
//                     ),
//                     trailing: Icon(
//                       _getFocusIcon(filteredTasks[index]['focus']!),
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   // دالة لتحديد لون الأولوية
//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.orange;
//       case 'Low':
//         return Colors.green;
//       default:
//         return Colors.blue;
//     }
//   }

//   // دالة لتحديد أيقونة مستوى التركيز
//   IconData _getFocusIcon(String focus) {
//     switch (focus) {
//       case 'Focused':
//         return Icons.check_circle;
//       case 'A little focused':
//         return Icons.remove_circle;
//       case 'Not focused':
//         return Icons.cancel;
//       default:
//         return Icons.help;
//     }
//   }
// }
import 'package:flutter/material.dart';
import '../helper/db_helper.dart';

class TaskListScreen extends StatefulWidget {
  final String? selectedFeel;
  final String? selectedEnergy;
  final String? selectedFocus;

  const TaskListScreen({
    super.key,
    required this.selectedFeel,
    required this.selectedEnergy,
    required this.selectedFocus,
  });

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final allTasks = await DBHelper.getData('USERTASK');

    // تصفية المهام بناءً على نتائج الاستبيان
    final filteredTasks = allTasks.where((task) {
      if (widget.selectedFocus == 'Focused' && task['focusLevel'] == 'Focused') {
        return true;
      } else if (widget.selectedFocus == 'A little focused' &&
          task['focusLevel'] == 'A little focused') {
        return true;
      } else if (widget.selectedFocus == 'Not focused' &&
          task['focusLevel'] == 'Not focused') {
        return true;
      }
      return false;
    }).toList();

    setState(() {
      tasks = filteredTasks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Tasks'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tasks.isEmpty
              ? const Center(
                  child: Text('No tasks match your current state.'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.task,
                          color: _getPriorityColor(tasks[index]['priority']),
                        ),
                        title: Text(
                          tasks[index]['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Priority: ${tasks[index]['priority']} | Focus: ${tasks[index]['focusLevel']}',
                        ),
                        trailing: Icon(
                          _getFocusIcon(tasks[index]['focusLevel']),
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // دالة لتحديد لون الأولوية
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  // دالة لتحديد أيقونة مستوى التركيز
  IconData _getFocusIcon(String focus) {
    switch (focus) {
      case 'Focused':
        return Icons.check_circle;
      case 'A little focused':
        return Icons.remove_circle;
      case 'Not focused':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
