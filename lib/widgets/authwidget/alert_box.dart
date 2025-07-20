import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertBox extends StatefulWidget {
  const AlertBox({super.key});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_email") ?? "email@example.com";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xFFFF6B6B)),
      ),
      title: const Text("Verification Code Sent"),
      content: FutureBuilder<String>(
        future: getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return Text(
              "A verification code has been sent to your email ${snapshot.data}. Please check your inbox and enter the code to complete the signup process.",
            );
          }
        },
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Color(0xFFFF6B6B)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
