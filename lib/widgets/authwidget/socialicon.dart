import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class Socialicon extends StatelessWidget {
  const Socialicon({required this.icon, required this.onPressed, super.key});

  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ListTile(leading: SignInButton(Buttons.Google, onPressed: onPressed)),
        ],
      ),
    );
  }
}
