import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ChatInputfeild extends StatelessWidget {
  const ChatInputfeild({
    required this.onSend,
    required this.controller,
    super.key,
  });

  final TextEditingController controller;
  final void Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.values[0],
            controller: controller,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.add, color: Color(0xFFFF6B6B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Color(0xFFFF6B6B)),
              ),
              hintText: 'Type a message...',
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 14.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            onSend();
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B6B),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.send_1, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
