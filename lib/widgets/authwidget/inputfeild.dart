import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Inputfeild extends StatelessWidget {
  const Inputfeild({
    required this.validator,
    required this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardtype,
    this.suficIcon,
    this.isVisible = false,
    required this.icon,
    required this.hinttxt,
    super.key,
  });

  final String hinttxt;
  final HeroIcon icon;
  final bool isVisible;
  final Widget? suficIcon;
  final TextInputType? keyboardtype;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      textCapitalization: textCapitalization,
      keyboardType: keyboardtype,
      obscureText: isVisible,
      decoration: InputDecoration(
        suffixIcon: suficIcon,
        hintText: hinttxt,
        prefixIcon: icon,
        filled: true,
        fillColor: Color(0xFFF8F8F8), // Light grey background
        // Default border (unfocused)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // Enabled border (still unfocused but enabled)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // Focused border (active state)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade400, // Grey border
            width: 2.0,
          ),
        ),

        // Error border (if validation fails)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),

        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),

        // Padding inside the field
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
