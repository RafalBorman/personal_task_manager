import 'package:flutter/material.dart';
import 'package:personal_task_manager/model/database/database.dart';
import 'package:personal_task_manager/model/notification_service.dart';
import 'package:personal_task_manager/model/tasks.dart';
import 'package:personal_task_manager/screens/home_screen.dart';

import '../utils/constants.dart';

class ModifyTask extends StatefulWidget {
  final Task task;

  const ModifyTask({super.key, required this.task});

  @override
  ModifyTaskState createState() => ModifyTaskState();
}

class ModifyTaskState extends State<ModifyTask> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late String _priorityValue;
  late int _priorityIntValue;
  late String _statusValue;
  late int _statusIntValue;
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _ownerController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.parse(widget.task.taskDeadline);
    _priorityValue = widget.task.priority == 3
        ? "High"
        : widget.task.priority == 2
            ? "Medium"
            : "Low";
    _priorityIntValue = widget.task.priority;
    _statusValue = widget.task.taskStatus == 3
        ? "Done"
        : widget.task.taskStatus == 2
            ? "Executing"
            : "Planned";
    _statusIntValue = widget.task.taskStatus;
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _taskDescriptionController =
        TextEditingController(text: widget.task.taskDescription);
    _ownerController = TextEditingController(text: widget.task.owner);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBGColor,
        appBar: AppBar(
          backgroundColor: mainOrange,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const Icon(Icons.arrow_back_ios_new),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Text("Add task"),
              GestureDetector(
                  onTap: () {
                    DatabaseHelper.instance.deleteTask(widget.task);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    counterText: '',
                  ),
                  maxLength: 20,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter task name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    hintText: 'Enter task description (max 100 characters)',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 100,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter task description';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    const Text('Deadline: '),
                    TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Priority: '),
                    DropdownButton<String>(
                      value: _priorityValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Standard') {
                            _priorityIntValue = 1;
                          } else if (newValue == 'Medium') {
                            _priorityIntValue = 2;
                          } else {
                            _priorityIntValue = 3;
                          }
                          _priorityValue = newValue!;
                        });
                      },
                      items: <String>['Low', 'Medium', 'High']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Status: '),
                    DropdownButton<String>(
                      value: _statusValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Planned') {
                            _statusIntValue = 1;
                          } else if (newValue == 'Executing') {
                            _statusIntValue = 2;
                          } else {
                            _statusIntValue = 3;
                          }
                          _statusValue = newValue!;
                        });
                      },
                      items: <String>['Planned', 'Executing', 'Done']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _ownerController,
                  decoration: const InputDecoration(labelText: 'Owner'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter owner name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveTask();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      minimumSize: const Size(250, 50),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: mainOrange,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    DatabaseHelper.instance.updateTask(Task(
        id: widget.task.id,
        taskName: _taskNameController.text,
        taskDescription: _taskDescriptionController.text,
        taskDeadline: _selectedDate.toString(),
        priority: _priorityIntValue,
        owner: _ownerController.text,
        taskStatus: _statusIntValue)); //:TODO
    LocalNotificationService().cancelTimedNotification(widget.task.id!);
    LocalNotificationService().showTimedNotification(
        widget.task.id!,
        _taskNameController.text,
        _taskDescriptionController.text,
        _selectedDate);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }
}
