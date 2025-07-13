import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationFeild extends StatelessWidget {
  const VerificationFeild({required this.controller,super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: TextFormField(controller: controller,
            onChanged: (value) {
              //logic here
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty) {
                FocusScope.of(context).previousFocus();
              }
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF4A4A),
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              focusColor: Color(0xFFFFF1F1),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFFF8A8A)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              filled: true,
              fillColor: Color(0xFFF8F8F8),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFFF8A8A)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
