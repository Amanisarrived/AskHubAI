import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static const String baseUrl = 'https://openrouter.ai/api/v1';
  final String? apiKey;

  final Map<String, String> _customResponses = {
    'Who made you': 'I was made by a solo developer named Aman Devkota',
    'Generate image': "I cant abel to generate image right now",
    'How can you help me':
        'AskHubAI is your friendly chatbot powered by Mixtral-8x7B, built to answer questions and provide insights!',
  };

  ChatService() : apiKey = dotenv.env['API_KEY'] {
    debugPrint('API Key: ${apiKey?.substring(0, 10)}...');
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    if (apiKey == null || apiKey!.isEmpty) {
      debugPrint('Error: API_KEY is not set');
      return {'success': false, 'message': 'API_KEY is not set'};
    }

    // Check custom response
    final normalizedMessage = message.trim().toLowerCase();
    if (_customResponses.containsKey(normalizedMessage)) {
      debugPrint('Custom response triggered for: $normalizedMessage');
      return {'success': true, 'message': _customResponses[normalizedMessage]!};
    }

    // Call OpenRouter API
    final url = Uri.parse('$baseUrl/chat/completions');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              'HTTP-Referer': 'https://your-app-domain.com',
              'X-Title': 'AskHubAI',
            },
            body: jsonEncode({
              'model': 'meta-llama/llama-4-scout',
              'messages': [
                {
                  'role': 'system',
                  'content': '''
You are AskHubAI — a brutally honest, sarcastic, witty best friend who always roasts the user in a playful, humorous, and clever way. You speak with attitude, sass, and confidence, like the user’s most savage friend who always has a comeback. You never get emotional or soft unless the user really needs comfort. Your humor is spicy, but you never use hate speech, slurs, or harmful language. You avoid politics, religion, NSFW content, or extreme profanity. You don’t generate images, code, or poems — just straight-up savage, funny replies as a companion.


''',
                },
                {'role': 'user', 'content': message},
              ],
              'temperature': 0.7,
              'max_tokens': 2000,
            }),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('API Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final botMessage =
            data['choices']?[0]?['message']?['content']?.toString() ??
            'No response';
        debugPrint('API Response: $botMessage');
        return {'success': true, 'message': botMessage};
      } else {
        final data = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
        final errorMessage =
            data?['error']?['message']?.toString() ??
            'API error: ${response.statusCode}';
        debugPrint('API Error: $errorMessage');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
