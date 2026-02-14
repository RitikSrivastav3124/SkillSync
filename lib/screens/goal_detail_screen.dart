import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/providers/auth_providers.dart';
import 'package:skillsync/services/ai_service.dart';
import 'package:skillsync/services/firestore_service.dart';
import '../models/task_model.dart';

class GoalDetailScreen extends StatefulWidget {
  final String goalId;
  final String goalTitle;
  final String goalDescription;

  const GoalDetailScreen({
    super.key,
    required this.goalId,
    required this.goalTitle,
    required this.goalDescription,
  });

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final TextEditingController taskController = TextEditingController();
  final AIService _aiService = AIService();

  void _showEditDialog(TaskModel task, FirestoreService firestoreService) {
    final editController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: "Enter new task title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editController.text.isEmpty) return;

              await firestoreService.updateTask(
                widget.goalId,
                task.id,
                editController.text.trim(),
              );

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final firestoreService = FirestoreService(user.uid);
    return Scaffold(
      appBar: AppBar(title: Text(widget.goalTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = 800;
          int crossAxisCount = 1;

          if (constraints.maxWidth >= 1200) {
            maxWidth = 1100;
            crossAxisCount = 2;
          } else if (constraints.maxWidth >= 800) {
            maxWidth = 900;
            crossAxisCount = 2;
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  /// AI Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final tasks = await _aiService.generateSubtasks(
                              widget.goalTitle,
                              widget.goalDescription,
                            );

                            for (var task in tasks) {
                              await firestoreService.addTask(
                                widget.goalId,
                                task,
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("AI Subtasks Added!"),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("AI failed: $e")),
                            );
                          }
                        },
                        child: const Text("Generate AI Subtasks"),
                      ),
                    ),
                  ),

                  /// Task List
                  Expanded(
                    child: StreamBuilder<List<TaskModel>>(
                      stream: firestoreService.getTasks(widget.goalId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final tasks = snapshot.data!;

                        if (tasks.isEmpty) {
                          return const Center(
                            child: Text(
                              "No Tasks Yet",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: tasks.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 4,
                              ),
                          itemBuilder: (context, index) {
                            final task = tasks[index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: task.isCompleted,
                                      onChanged: (_) {
                                        firestoreService.toggleTask(
                                          widget.goalId,
                                          task.id,
                                          task.isCompleted,
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          "${index + 1}. ${task.title}",
                                          style: TextStyle(
                                            decoration: task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditDialog(task, firestoreService);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        firestoreService.deleteTask(
                                          widget.goalId,
                                          task.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      /// Bottom Add Task Section
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(hintText: "Add new task"),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (taskController.text.isEmpty) return;

                    await firestoreService.addTask(
                      widget.goalId,
                      taskController.text.trim(),
                    );

                    taskController.clear();
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
