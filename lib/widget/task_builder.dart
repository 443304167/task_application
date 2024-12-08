
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';
import '../helper/notification_service.dart';
import '../models/user_task.dart';

class TaskBuilder extends StatefulWidget {
  final String? filter;
  const TaskBuilder({required this.filter, super.key});

  @override
  State<TaskBuilder> createState() => _TaskBuilderState();
}

class _TaskBuilderState extends State<TaskBuilder> {
  var isInit = false;

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) _fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TasksProvider>(context);
    final userList = widget.filter! == 'NoGroup'
        ? user.userTaskList
        : user.groupList(widget.filter!);
    final mediaQuery = MediaQuery.of(context);

    return userList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No tasks available!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/notask.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  'Add some tasks to get started!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskTile(
                    user: user,
                    userList: userList,
                    index: index,
                  );
                },
              );
  }

  void _fetchData() async {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isInit = false;
      });
    });
    await Provider.of<TasksProvider>(context, listen: false).fetchData();
  }
}

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.user,
    required this.userList,
    required this.index,
  });

  final TasksProvider user;
  final List<UserTask> userList;
  final int index;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    notificationService.initializeNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final tempIndex = widget.user.userTaskList.indexWhere(
          (element) => element.id == widget.userList[widget.index].id,
        );
        widget.user.deleteTask(tempIndex);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure!'),
            content: const Text('This will delete the current task!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      background: const Card(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.userList[widget.index].imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          title: Text(
            widget.userList[widget.index].title,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              decoration: widget.userList[widget.index].isDone
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.userList[widget.index].description != null)
                Text(
                  widget.userList[widget.index].description!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: widget.userList[widget.index].isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              Text(
                'Priority: ${widget.userList[widget.index].priority}',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              Text(
                'Focus Level: ${widget.userList[widget.index].focusLevel}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ),
          trailing: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            children: [
              Text(
                widget.userList[widget.index].startingDate == null
                    ? ''
                    : DateFormat.MMMMd('en_US')
                        .format(widget.userList[widget.index].startingDate!),
              ),
              Consumer<TasksProvider>(
                builder: (context, user, _) {
                  return Checkbox(
                    value: widget.userList[widget.index].isDone,
                    onChanged: (value) {
                      final indexTemp = user.userTaskList
                          .indexOf(widget.userList[widget.index]);
                      final check = user.userTaskList[indexTemp].isDone;
                      user.taskDone(indexTemp, check);
                      if (value == false) {
                        notificationService.scheduleNotification(
                          widget.userList[widget.index].title,
                          "Task Pending",
                          int.parse(widget.userList[widget.index].id),
                        );
                      } else {
                        notificationService.stopNotification(
                          int.parse(widget.userList[widget.index].id),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
