import 'package:flutter/material.dart';

import '../../model/chat_model.dart';
import '../apiservice/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<ChatModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _messages.add(ChatModel(role: 'user', content: message));
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(message);
      if (response['success']) {
        _messages.add(
          ChatModel(role: 'assistant', content: response['message']),
        );
      } else {
        _errorMessage = _formatError(response['message']);
      }
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatError(String message) {
    if (message.contains('Rate limit exceeded')) {
      return 'Rate limit reached. Please wait a few seconds and try again.';
    } else if (message.contains('OPENROUTER_API_KEY is not set')) {
      return 'API configuration error. Please contact support.';
    } else if (message.contains('Network error')) {
      return 'Network issue. Check your internet connection and try again.';
    } else {
      return 'Error: $message';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
