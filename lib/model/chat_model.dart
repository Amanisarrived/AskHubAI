class ChatModel {
  ChatModel({required this.content, required this.role});
  final String role;
  final String content;

  Map<String, String> toMap() => {'role': role, 'content': content};

  factory ChatModel.fromMap(Map<String, dynamic> map) =>
      ChatModel(role: map['role'] as String, content: map['content'] as String);
}
