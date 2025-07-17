import 'package:ashub_chatai/repo/apiservice/chat_saving_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../model/chat_model.dart';
import '../apiservice/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ChatSavingService _chatSavingService = ChatSavingService();
  final List<ChatModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentConversationId;
  List<Map<String, dynamic>> _savedConversations = [];

  List<ChatModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentConversationId => _currentConversationId;
  List<Map<String, dynamic>> get savedConversations => _savedConversations;

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _messages.add(ChatModel(role: 'user', content: message));
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(message);
      print('ChatService response: $response'); // Debug
      if (response['success']) {
        _messages.add(
          ChatModel(role: 'assistant', content: response['message']),
        );
        await _autoSaveConversation(); // Call auto-save after adding assistant response
      } else {
        _errorMessage = _formatError(response['message']);
        print('ChatService failed: ${response['message']}'); // Debug
      }
    } catch (e) {
      _errorMessage = _formatError('Message send error: $e');
      print('Message send error: $e'); // Debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _autoSaveConversation() async {
    try {
      _currentConversationId ??= Uuid().v4();
      final title =
          _savedConversations.firstWhere(
                (chat) => chat['conversationId'] == _currentConversationId,
                orElse: () => {
                  'title':
                      'Chat ${DateTime.now().toIso8601String().substring(0, 19)}',
                },
              )['title']
              as String;
      final messagesMap = _messages.map((m) => m.toMap()).toList();
      print(
        'Saving conversation: ID=$_currentConversationId, Title=$title, Messages=$messagesMap',
      ); // Debug
      await _chatSavingService.saveChat(
        _currentConversationId!,
        title,
        messagesMap,
      );
      print('Conversation saved successfully'); // Debug
      await loadSavedConversations();
    } catch (e) {
      _errorMessage = _formatError('Failed to auto-save conversation: $e');
      print('Auto-save error: $_errorMessage'); // Debug
      notifyListeners();
    }
  }

  Future<void> loadSavedConversations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedConversations = await _chatSavingService.getAllChats();
      print('Loaded conversations: $_savedConversations'); // Debug
    } catch (e) {
      _savedConversations = [];
      _errorMessage = _formatError('Failed to load conversations: $e');
      print('Load conversations error: $e'); // Debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadConversation(String conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversation = _savedConversations.firstWhere(
        (chat) => chat['conversationId'] == conversationId,
        orElse: () => throw Exception('Conversation not found'),
      );
      _currentConversationId = conversationId;
      _messages.clear();
      _messages.addAll(
        (conversation['messages'] as List)
            .map((m) => ChatModel.fromMap(m))
            .toList(),
      );
      print(
        'Loaded conversation: $conversationId, Messages: $_messages',
      ); // Debug
    } catch (e) {
      _errorMessage = _formatError('Failed to load conversation: $e');
      print('Load conversation error: $e'); // Debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSavedConversation(String conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _chatSavingService.deleteChat(conversationId);
      _savedConversations.removeWhere(
        (chat) => chat['conversationId'] == conversationId,
      );
      if (_currentConversationId == conversationId) {
        _messages.clear();
        _currentConversationId = null;
      }
      print('Deleted conversation: $conversationId'); // Debug
    } catch (e) {
      _errorMessage = _formatError('Failed to delete conversation: $e');
      print('Delete conversation error: $e'); // Debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatError(String message) {
    if (message.contains('Rate limit')) {
      return 'Rate limit reached. Please wait a few seconds and try again.';
    } else if (message.contains('No token found')) {
      return 'Please log in to continue.';
    } else if (message.contains('Failed to save chat')) {
      return 'Failed to save conversation. Please try again.';
    } else if (message.contains('Failed to load chats')) {
      return 'Unable to load conversations. Please check your connection.';
    } else if (message.contains('Failed to delete chat')) {
      return 'Unable to delete conversation. Please try again.';
    } else if (message.contains('Conversation not found')) {
      return 'The selected conversation could not be found.';
    } else if (message.contains('OPENROUTER_API_KEY')) {
      return 'API configuration error. Please contact support.';
    } else {
      return 'An error occurred: $message';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _currentConversationId = null;
    _errorMessage = null;
    notifyListeners();
  }
}
