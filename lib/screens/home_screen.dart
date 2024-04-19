import 'package:flutter/material.dart';
import 'package:personal_task_manager/model/tasks.dart';
import 'package:personal_task_manager/screens/add_task_screen.dart';
import 'package:personal_task_manager/screens/modify_task_screen.dart';
import 'package:personal_task_manager/utils/constants.dart';
import 'package:personal_task_manager/widgets/todo_task.dart';
import 'package:personal_task_manager/widgets/weather_condition.dart';

import '../model/database/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  late String orderBy;

  @override
  void initState() {
    orderBy = 'id';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          elevation: 20,
          backgroundColor: mainBGColor,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: mainOrange,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.insert_chart_outlined),
              selectedIcon: Icon(Icons.insert_chart),
              label: 'Stats',
            ),
          ],
        ),
        body: <Widget>[
          Scaffold(
            backgroundColor: mainBGColor,
            appBar: AppBar(
              backgroundColor: mainOrange,
              title: Row(
                children: [
                  const Expanded(child: Text("Task manager")),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton(
                              icon: const Icon(Icons.filter_list_sharp),
                              onSelected: (item) {
                                setState(() {
                                  orderBy = item;
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'id',
                                    child: Text('Order by id'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'task_name',
                                    child: Text('Order by name'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'task_description',
                                    child: Text('Order by description'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'task_deadline',
                                    child: Text('Order by deadline'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'task_deadline desc',
                                    child: Text('Order by deadline desc'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'priority desc',
                                    child: Text('Order by priority'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'task_status desc',
                                    child: Text('Order by status'),
                                  ),
                                ];
                              })))
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const WeatherWidget(),
                    FutureBuilder<List<Task>>(
                      future: DatabaseHelper.instance.getTasks(orderBy),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Task>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: mainOrange,
                          ));
                        }
                        return snapshot.data!.isEmpty
                            ? const Center(child: Text('No tasks in List.'))
                            : ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: snapshot.data!.map((task) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ModifyTask(task: task),
                                          ),
                                        );
                                      },
                                      child: ToDoTask(task: task));
                                }).toList(),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddTask(),
                  ),
                );
              },
              backgroundColor: mainOrange,
              child: const Icon(Icons.add),
            ),
          ),
          Scaffold(
            backgroundColor: mainBGColor,
            appBar: AppBar(
              backgroundColor: mainOrange,
              title: const Text("Task manager stats"),
              centerTitle: false,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Expanded(
                      child: FutureBuilder<Map<String, int?>>(
                    future: DatabaseHelper.instance.getTasksStats(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, int?>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: mainOrange,
                        ));
                      }
                      return snapshot.data!.isEmpty
                          ? const Center(
                              child: Text('No tasks in List to make stats.'))
                          : Center(
                              child: Column(children: [
                                Text(
                                    "Completed tasks for today: ${snapshot.data!['countDoneTasks']}"),
                                Text(
                                    "Tasks still executing: ${snapshot.data!['countExecutingTasks']}"),
                                Text(
                                    "Planned tasks for today: ${snapshot.data!['countPlannedTasks']}"),
                              ]),
                            );
                    },
                  )),
                ],
              ),
            ),
          ),
        ][currentPageIndex],
      ),
    );
  }
}
