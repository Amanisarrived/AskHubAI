import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatSavingService {
  final String baseUrl =
      'https://askhubaibackend-production.up.railway.app'; // Replace with your actual API base URL, e.g., 'http://localhost:3000'

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    print('Retrieved token: $token'); // Debug
    return token;
  }

  Future<void> saveChat(
    String conversationId,
    String title,
    List<Map<String, String>> messages,
  ) async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');
    final url = '$baseUrl/api/auth/save';
    final payload = {
      'conversationId': conversationId,
      'title': title,
      'messages': messages,
    };
    print('Saving to URL: $url, Data: ${json.encode(payload)}'); // Debug
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(payload),
    );
    print(
      'Save response: Status=${response.statusCode}, Body=${response.body}',
    ); // Debug
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Failed to save chat: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllChats() async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');
    final url = '$baseUrl/api/auth/all';
    print('Fetching chats from URL: $url'); // Debug
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(
      'GetAllChats response: Status=${response.statusCode}, Body=${response.body}',
    ); // Debug
    if (response.statusCode == 200) {
      final chats = List<Map<String, dynamic>>.from(json.decode(response.body));
      print('Parsed chats: $chats'); // Debug
      return chats;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception(
        'Failed to load chats: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<void> deleteChat(String conversationId) async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');
    final url = '$baseUrl/api/authdelete/$conversationId';
    print('Deleting chat from URL: $url'); // Debug
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(
      'Delete response: Status=${response.statusCode}, Body=${response.body}',
    ); // Debug
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete chat: ${response.statusCode}, ${response.body}',
      );
    }
  }
}
