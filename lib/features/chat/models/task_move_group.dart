class TaskMoveGroup {
  final List<int> taskIds;
  final int destinationColumnId;

  TaskMoveGroup({
    required this.taskIds,
    required this.destinationColumnId,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskIds': taskIds,
      'destinationColumnId': destinationColumnId,
    };
  }
}
