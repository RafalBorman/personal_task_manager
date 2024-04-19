import 'package:flutter/material.dart';
import 'package:personal_task_manager/model/database/database.dart';
import 'package:personal_task_manager/model/tasks.dart';
import 'package:personal_task_manager/screens/home_screen.dart';

import '../utils/constants.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  late String _priorityValue;
  late int _priorityIntValue;
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _ownerController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _priorityValue = 'Low';
    _priorityIntValue = 1;
    _taskNameController = TextEditingController();
    _taskDescriptionController = TextEditingController();
    _ownerController = TextEditingController();
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
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios_new),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Add task"),
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
                    hintText: 'Enter task description',
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
                          if (newValue == 'Low') {
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
    DatabaseHelper.instance.addTask(Task(
        taskName: _taskNameController.text,
        taskDescription: _taskDescriptionController.text,
        taskDeadline: _selectedDate.toString(),
        priority: _priorityIntValue,
        owner: _ownerController.text));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }
}
