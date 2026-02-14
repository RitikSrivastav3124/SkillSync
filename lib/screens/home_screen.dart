import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillsync/models/goal_model.dart';
import 'package:skillsync/providers/auth_providers.dart';
import 'package:skillsync/screens/add_goal_screen.dart';
import 'package:skillsync/screens/goal_detail_screen.dart';
import 'package:skillsync/services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return (text[0].toUpperCase() + text.substring(1));
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
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authProvider.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 1;
          double maxWidth = 600;

          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 3;
            maxWidth = 1100;
          } else if (constraints.maxWidth >= 800) {
            crossAxisCount = 2;
            maxWidth = 900;
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: StreamBuilder<List<GoalModel>>(
                stream: firestoreService.getGoals(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final goals = snapshot.data!;

                  if (goals.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: goals.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3.2,
                    ),
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return _buildGoalCard(context, goal, firestoreService);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),

      /// Full Width Footer Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(
                "New Goal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddGoalScreen()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Goal Card
  Widget _buildGoalCard(
    BuildContext context,
    GoalModel goal,
    FirestoreService service,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GoalDetailScreen(
                goalId: goal.id,
                goalTitle: goal.title,
                goalDescription: goal.description,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBE2EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag_rounded, color: Color(0xFF3F72AF)),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      capitalizeFirst(goal.title),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      capitalizeFirst(goal.description),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.grey,
                onPressed: () {
                  service.deleteGoal(goal.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.track_changes_rounded,
              size: 60,
              color: Color(0xFF3F72AF),
            ),
            SizedBox(height: 18),
            Text(
              "No Goals Yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Start by adding your first learning goal.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
