import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:personal_task_manager/model/tasks.dart';
import 'package:personal_task_manager/utils/constants.dart';

class ToDoTask extends StatelessWidget {
  final Task task;

  const ToDoTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.taskName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: mainOrange),
                ),
                Icon(
                  task.taskStatus == 3
                      ? Icons.check_box
                      : task.taskStatus == 2
                          ? Icons.pending
                          : Icons.check_box_outline_blank,
                  color: mainOrange,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    task.taskDescription,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: lightAccentBlue,
                    size: 12,
                  ),
                  Text(" ${Jiffy.parse(task.taskDeadline).yMEd}",
                      style: TextStyle(color: lightAccentBlue, fontSize: 12)),
                  Spacer(),
                  Text(
                      "Priority: ${task.priority == 3 ? "High" : task.priority == 2 ? "Medium" : "Low"}",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 12))
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
