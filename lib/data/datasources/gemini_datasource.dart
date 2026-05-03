import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config.dart';

class GeminiDataSource {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> fetchTechNewsSummary() async {
    final apiKey = Config.geminiApiKey;

    if (apiKey.isEmpty) {
      throw Exception('API key is missing!');
    }

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final body = jsonEncode({
      "system_instruction": {
        "parts": [
          {
            "text":
                "You are an expert news reporter. Give bullet points summarizing the latest tech news."
          }
        ]
      },
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "Latest tech news summary in last 24 hours."}
          ]
        }
      ],
      "tools": [
        {"google_search": {}}
      ]
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      throw Exception('Gemini Error: ${response.statusCode}');
    }
  }
}