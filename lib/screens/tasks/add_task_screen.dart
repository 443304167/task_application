import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/providers/tasks_provider.dart';
import '/helper/notification_service.dart';
class AddTask extends StatefulWidget {
  static const routeName = '/add-task';

  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? startDate;

  final titleText = TextEditingController();
  final descText = TextEditingController();

  String dropDownValue = 'Self';
  String priorityDropdownValue = 'High'; 
  String focusDropdownValue = 'High'; 

  bool isStrechedDropDown = false;

  final DateTime _date = DateTime.now();

  // var listItems = [
  //   'Office',
  //   'Home',
  //   'Self',
  // ];

  var priorityItems = [
    'High',
    'Medium',
    'Low',
  ];

  var focusItems = [
    'High',
    'Medium',
    'Low',
  ];

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    titleText.dispose();
    descText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Task'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customTextField('Title', titleText),
            customHeight(context),
            customTextField('Description', descText),
            customHeight(context),

            // اختيار التاريخ
            Padding(
              padding: const EdgeInsets.all(10),
              child: dateButtonDecoration(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor:
                          startDate == null ? Colors.black45 : Colors.white,
                      backgroundColor: startDate == null
                          ? Colors.grey[300]
                          : Theme.of(context).colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectStartDate();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: startDate == null
                          ? Text(
                              'Select Date',
                              style: TextStyle(
                                  fontSize: mediaQuery.textScaleFactor * 17),
                            )
                          : Text(
                              DateFormat.MMMMd('en_US').format(startDate!),
                              style: TextStyle(
                                  fontSize: mediaQuery.textScaleFactor * 17),
                            ),
                    ),
                  ),
                  context),
            ),
            customHeight(context),

            // قائمة الأولوية
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: priorityDropdownValue,
                  isExpanded: true,
                items: priorityItems
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priorityDropdownValue = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Priority',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // قائمة مستوى التركيز
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: focusDropdownValue,
                  isExpanded: true,
                items: focusItems
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    focusDropdownValue = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Focus Level',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),


  
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: DropdownButtonFormField<String>(
            //     value: dropDownValue,
            //       isExpanded: true,
            //     items: listItems
            //         .map((item) => DropdownMenuItem(
            //               value: item,
            //               child: Text(item),
            //             ))
            //         .toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         dropDownValue = value!;
            //       });
            //     },
            //     decoration: InputDecoration(
            //       labelText: 'Tybe ',
            //       filled: true,
            //       fillColor: Colors.grey[300],
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(15),
            //         borderSide: BorderSide.none,
            //       ),
            //     ),
            //   ),
            // ),
        
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submitData(context);
        },
        child: const Icon(Icons.done_outline_rounded),
      ),
    );
  }

  void _submitData(BuildContext context) {
    final taskTitle = titleText.text.trim();
    final taskDesc = descText.text.trim();

    if (taskTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a title for the task!'),
        ),
      );
      return;
    }

    // إرسال القيم إلى المزود (Provider)
    Provider.of<TasksProvider>(context, listen: false).addTask(
      taskTitle,
      taskDesc,
      startDate,
      dropDownValue.toLowerCase(),
      _date,
      priorityDropdownValue,
      focusDropdownValue,
    );

    Navigator.of(context).pop();
  }

    Widget customTextField(String hintText, TextEditingController txController) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
        controller: txController,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }



  Widget customHeight(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget dateButtonDecoration(ElevatedButton button, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
      width: double.infinity,
      height: isLandscape ? size.width * 0.06 : size.height * 0.075,
      child: button,
    );
  }

  void _selectStartDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        startDate = pickedDate;
      });
    });
  }

}

