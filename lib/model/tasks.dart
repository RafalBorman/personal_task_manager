class Task {
  final int? id;
  final String taskName;
  final String taskDescription;
  final String taskDeadline;
  final int priority;
  final String owner;
  final int taskStatus;

  Task(
      {this.id,
      required this.taskName,
      required this.taskDescription,
      required this.taskDeadline,
      required this.priority,
      required this.owner,
      this.taskStatus = 1});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'task_name': taskName,
      'task_description': taskDescription,
      'task_deadline': taskDeadline,
      'priority': priority,
      'owner': owner,
      'task_status': taskStatus,
    };
  }
}
