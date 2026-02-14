import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/providers/auth_providers.dart';
import '../services/firestore_service.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // ✅ If user null → prevent crash
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final firestoreService = FirestoreService(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Goal",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = 500;

            if (constraints.maxWidth >= 1000) {
              maxWidth = 600;
            } else if (constraints.maxWidth >= 700) {
              maxWidth = 550;
            }

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 24 : 40,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header
                          Center(
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.flag_rounded,
                                  size: 46,
                                  color: Color(0xFF3F72AF),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Create New Goal",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Define your learning objective",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),

                          /// Goal Title
                          const Text(
                            "Goal Title",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              hintText: "Enter goal title",
                              prefixIcon: Icon(Icons.title),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Description
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Enter goal description",
                              prefixIcon: Icon(Icons.description_outlined),
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// Add Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (titleController.text.isEmpty) return;

                                try {
                                  await firestoreService.addGoal(
                                    titleController.text.trim(),
                                    descController.text.trim(),
                                  );

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed to add goal"),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Add Goal",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
