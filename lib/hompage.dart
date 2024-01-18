import 'package:flutter/material.dart';
import 'package:task_app/constants/date_formatter.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/services/database_service.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _databaseService = DatabaseService();
  final _taskTextController = TextEditingController();

  void _getTaskList() async {
    await _databaseService.getAllTasks();
    setState(() {});
  }

  void _addTask() async {
    if (_taskTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.deepPurpleAccent,
          content: Text(
            'Please enter a task!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          showCloseIcon: true,
        ),
      );
    } else {
      await _databaseService.addTask(_taskTextController.text).then((value) {
        // show toast
        toastification.show(
          context: context,
          alignment: Alignment.topCenter,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('TASK ADDED'),
          description: const Text('New task added successfully!'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      });
    }
    setState(() {
      _taskTextController.clear();
    });
  }

  @override
  void initState() {
    _getTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK APP'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _taskListWidget(),
            const Divider(
              height: 1,
              thickness: 0,
              color: Colors.grey,
            ),
            _addTaskWidget(),
          ],
        ),
      ),
    );
  }

  Container _addTaskWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      child: TextField(
        controller: _taskTextController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              // add task
              _addTask();

              // dismiss keyboard
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(
              Icons.add_box_rounded,
              size: 26,
            ),
          ),
          hintText: 'Enter a task',
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Expanded _taskListWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: _databaseService.currentTasks.length,
        itemBuilder: (BuildContext context, int index) {
          final Task task = _databaseService.currentTasks[index];
          return ListTile(
            title: Text(
              task.taskText,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              formatCreatedDate(task.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) async {
                await _databaseService.updateTask(
                  id: task.id,
                  text: task.taskText,
                  isComplated: value!,
                );
                setState(() {});
              },
            ),
            trailing: IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                            onPressed: () async {
                              await _databaseService.deleteTask(task.id);
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: const Text('Yes')),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            thickness: 0,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
