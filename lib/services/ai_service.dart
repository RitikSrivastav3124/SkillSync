import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillsync/utils/api_key.dart';

class AIService {
  final String _apiKeyValue = APIKey.groqKey;

  Future<List<String>> generateSubtasks(
    String goal,
    String goalDescription,
  ) async {
    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_apiKeyValue",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {
            "role": "user",
            "content":
                "You are a productivity assistant.\n\n"
                "Break the following goal into exactly 5 clear, practical, and actionable subtasks.\n\n"
                "Goal Title: $goal\n"
                "Goal Description: $goalDescription\n\n"
                "Rules:\n"
                "- Keep subtasks short and specific\n"
                "- Each subtask must be actionable\n"
                "- Return only a numbered list",
          },
        ],
        "temperature": 0.7,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data["choices"][0]["message"]["content"] as String;

      final lines = text.split('\n');

      final cleanList = lines
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.replaceAll(RegExp(r'^\d+[\).\s-]*'), '').trim())
          .toList();

      return cleanList;
    } else {
      throw Exception(response.body);
    }
  }
}
