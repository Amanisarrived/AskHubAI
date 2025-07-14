import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repo/provider/chat_provider.dart';

class AlertBox extends StatelessWidget {
  const AlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return AlertDialog(
      title: Text("Clear Chat"),
      content: Text("Are you sure you want to clear the chat?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("Cancel"),
        ),

        TextButton(
          onPressed: () {
            chatProvider.clearMessages();
          },
          child: Text("Clear", style: TextStyle(color: Color(0xFFFF6B6B))),
        ),
      ],
    );
  }
}
