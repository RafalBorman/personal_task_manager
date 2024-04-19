import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:personal_task_manager/model/notification_service.dart';
import 'package:sqflite/sqflite.dart';

import '../tasks.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tasks_table" (
    "id"    INTEGER,
    "task_name"  TEXT,
    "task_description"    TEXT,
    "task_deadline"    TEXT,
    "priority"    INTEGER,
    "owner"    TEXT,
    "task_status"    INTEGER,
    PRIMARY KEY("id" AUTOINCREMENT)
);
      ''');
  }

  Future<List<Task>> getTasks(String orderBy) async {
    Database db = await instance.database;
    final List<Map<String, Object?>> taskQuery =
        await db.query('tasks_table', orderBy: orderBy);
    return [
      for (final {
            'id': id as int,
            'task_name': taskName as String,
            'task_description': taskDescription as String,
            'task_deadline': taskDeadline as String,
            'priority': priority as int,
            'owner': owner as String,
            'task_status': taskStatus as int
          } in taskQuery)
        Task(
            id: id,
            taskName: taskName,
            taskDescription: taskDescription,
            taskDeadline: taskDeadline,
            priority: priority,
            owner: owner,
            taskStatus: taskStatus),
    ];
  }

  Future<int> addTask(Task task) async {
    Database db = await instance.database;
    var response = await db.insert('tasks_table', {
      'task_Name': task.taskName,
      'task_description': task.taskDescription,
      'task_deadline': task.taskDeadline,
      'priority': task.priority,
      'owner': task.owner,
      'task_status': task.taskStatus
    });
    var maxID =
        (await db.rawQuery("SELECT max(id) FROM tasks_table"))[0]["max(id)"];
    LocalNotificationService().showTimedNotification(
        int.parse(maxID.toString()),
        task.taskName,
        task.taskDescription,
        DateTime.parse(task.taskDeadline).add(const Duration(minutes: 2)));
    return response;
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(
      'tasks_table',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(Task task) async {
    Database db = await instance.database;
    return await db.delete(
      'tasks_table',
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<Map<String, int?>> getTasksStats() async {
    String filterCriteria = Jiffy.now().format(pattern: "y-MM-d");
    Database db = await instance.database;
    int? countPlanned = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM tasks_table WHERE task_deadline LIKE '%$filterCriteria%' AND task_status=1"));
    int? countExecuting = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM tasks_table WHERE task_deadline LIKE '%$filterCriteria%' AND task_status=2"));
    int? countDone = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM tasks_table WHERE task_deadline LIKE '%$filterCriteria%' AND task_status=3"));
    return {
      "countPlannedTasks": countPlanned,
      "countExecutingTasks": countExecuting,
      "countDoneTasks": countDone
    };
  }
}
