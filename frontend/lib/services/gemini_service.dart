import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/mock_data.dart';

/// Port of services/geminiService.js
const String _apiKey = "AIzaSyBp4NRLgZfD2E2YxGdPTYsfo0FyY0hrL6k";

Future<List<String>> getTips(String type) async {
  try {
    final prompt = 'Give 10 simple $type for farmers in India in short numbered points';

    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API failed');
    }

    final data = jsonDecode(response.body);
    final text = data?['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

    return text
        .toString()
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  } catch (e) {
    return tipsMockData[type] ?? ["No data available"];
  }
}
